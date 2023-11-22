module Crm
  module Model::Maintain
    extend ActiveSupport::Concern

    included do
      attribute :remark, :string
      attribute :position, :integer

      enum state: {
        init: 'init',
        carted: 'carted',
        ordered: 'ordered'
      }, _default: 'init'

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :member, class_name: 'Org::Member', counter_cache: true, inverse_of: :maintains, optional: true
      belongs_to :task_template, class_name: 'Bench::TaskTemplate', optional: true if defined? RailsBench
      belongs_to :client_member, class_name: 'Org::Member', optional: true
      belongs_to :client_organ, class_name: 'Org::Organ', optional: true
      belongs_to :client_user, class_name: 'Auth::User', optional: true
      belongs_to :profile_agent, class_name: 'Profiled::Profile', foreign_key: :agent_id, optional: true

      belongs_to :client, inverse_of: :client_maintains
      belongs_to :contact, optional: true
      belongs_to :agent, polymorphic: true, inverse_of: :agent_maintains, optional: true
      belongs_to :agency, optional: true
      belongs_to :maintain_source, optional: true
      belongs_to :upstream, class_name: self.name, optional: true
      belongs_to :original, class_name: self.name, optional: true

      has_many :addresses, class_name: 'Profiled::Address', primary_key: [:member_id, :client_id, :contact_id], query_constraints: [:agent_id, :client_id, :contact_id]
      has_many :wallets, class_name: 'Trade::Wallet', primary_key: [:member_id, :client_id], query_constraints: [:agent_id, :client_id]
      has_many :cards, class_name: 'Trade::Card', primary_key: [:member_id, :client_id], query_constraints: [:agent_id, :client_id]
      has_many :carts, class_name: 'Trade::Cart', primary_key: [:member_id, :client_id], query_constraints: [:agent_id, :client_id]
      has_many :orders, class_name: 'Trade::Order', primary_key: [:member_id, :client_id], query_constraints: [:agent_id, :client_id]

      has_many :maintain_logs, dependent: :delete_all
      has_many :maintain_tags, -> { distinct }, through: :maintain_logs

      accepts_nested_attributes_for :client, reject_if: :all_blank
      accepts_nested_attributes_for :profile_agent, reject_if: :all_blank
      accepts_nested_attributes_for :agency, reject_if: :all_blank

      before_validation :sync_pipeline_member, if: -> { task_template_id_changed? }
      before_save :sync_organ_from_member, if: -> { client_member_id_changed? }
      after_save :sync_user_to_orders, if: -> { (saved_changes.keys & ['client_id', 'client_member_id']).present? }
      after_create_commit :init_stream!
    end

    def init_stream!
      self.upstream ||= self
      self.original ||= self
      self.save
    end

    def sync_pipeline_member
      #self.task_member ||= self.task_template.pipeline_members.first if self.pipeline
      #self.position = self.pipeline_member&.position
    end

    def name
      remark.presence || client.name
    end

    def tags
      ids = maintain_logs.pluck(:maintain_tag_id).uniq
      MaintainTag.cached.slice(*ids).values
    end

    def sync_user_to_orders
      orders.update_all member_id: client_member_id, member_organ_id: client_member&.organ_id
      wallets.update_all member_id: client_member_id, member_organ_id: client_member&.organ_id
      cards.update_all member_id: client_member_id, member_organ_id: client_member&.organ_id
    end

    def transfer!(next_member: pipeline_member&.next_member)
      if next_member
        m = Maintain.new
        m.upstream = self
        m.original = self.original
        m.member = next_member
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

    def sync_organ_from_member
      self.client_organ_id = client_member.organ_id
    end

  end
end
