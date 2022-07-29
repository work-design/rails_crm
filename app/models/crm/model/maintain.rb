module Crm
  module Model::Maintain
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :position, :integer
      attribute :deposit_ratio, :integer, default: 100, comment: '最小预付比例'
      attribute :client_type, :string, default: 'Profiled::Client'
      attribute :agent_type, :string, default: 'Profiled::Agent'

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :member, class_name: 'Org::Member', inverse_of: :maintains, optional: true
      belongs_to :task_template, class_name: 'Bench::TaskTemplate', optional: true
      belongs_to :payment_strategy, class_name: 'Trade::PaymentStrategy', optional: true

      belongs_to :client_user, class_name: 'Auth::User', optional: true
      belongs_to :client_member, class_name: 'Org::Member', optional: true
      belongs_to :profile_client, class_name: 'Profiled::Profile', foreign_key: :client_id, optional: true
      belongs_to :profile_agent, class_name: 'Profiled::Profile', foreign_key: :agent_id, optional: true
      accepts_nested_attributes_for :profile_agent, reject_if: :all_blank
      accepts_nested_attributes_for :profile_client, reject_if: :all_blank

      has_many :orders, class_name: 'Trade::Order', dependent: :nullify
      has_many :addresses, class_name: 'Profiled::Address', dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', dependent: :nullify

      belongs_to :client, polymorphic: true, inverse_of: :client_maintains, autosave: true, optional: true
      belongs_to :agent, polymorphic: true, inverse_of: :agent_maintains, optional: true
      belongs_to :agency, optional: true
      belongs_to :maintain_source, optional: true
      belongs_to :upstream, class_name: self.name, optional: true
      belongs_to :original, class_name: self.name, optional: true

      has_many :maintain_logs, dependent: :delete_all
      has_many :maintain_tags, -> { distinct }, through: :maintain_logs

      accepts_nested_attributes_for :agency, reject_if: :all_blank

      enum state: {
        init: 'init',
        ordered: 'ordered'
      }, _default: 'init'

      before_validation :init_stream, if: :new_record?
      before_validation :sync_pipeline_member, if: -> { task_template_id_changed? }
      after_save_commit :sync_user_to_orders, if: -> { (saved_changes.keys & ['client_user_id', 'client_member_id']).present? }
    end

    def init_stream
      self.upstream ||= self
      self.original ||= self
    end

    def sync_user_to_orders
      orders.each do |order|
        order.user_id = self.client.client_user_id
        order.member_id = self.client.client_member_id
        order.save
      end
      wallets.each do |wallet|
        wallet.user_id = client.client_user_id
        wallet.member_id = client.client_member_id
        wallet.save
      end
      cards.each do |card|
        card.user_id = client.client_user_id
        card.member_id = client.client_member_id
        card.save
      end
    end

    def sync_pipeline_member
      #self.task_member ||= self.task_template.pipeline_members.first if self.pipeline
      #self.position = self.pipeline_member&.position
    end

    def tags
      ids = maintain_logs.pluck(:maintain_tag_id).uniq
      MaintainTag.cached.slice(*ids).values
    end

    def transfer!
      next_member = pipeline_member&.next_member
      if next_member
        m = Maintain.new
        m.upstream = self
        m.original = self.original
        m.pipeline_member = next_member
        m.assign_attributes self.attributes.slice('organ_id', 'client_type', 'client_id', 'agent_type', 'agent_id', 'agency_id', 'maintain_source_id', 'pipeline_id')

        self.class.transaction do
          self.save!
          m.save!
        end
        m
      else
        self.save
      end
    end

    def confirm_booker_time!(booked)
      ml = self.maintain_logs.build
      ml.member = self.member
      ml.note = "已预约成功"
      ml.logged = booked
      mt = option_maintain_tags.find_by(logged_type: booked.class.name)
      if mt
        ml.maintain_tag = mt
      end
      ml.extra = {
        booked_type: booked.booked_type,
        booked_id: booked.booked_id
      }
      ml.save
    end

    def option_maintain_tags
      MaintainTag.where(organ_id: self.organ_id)
    end

  end
end
