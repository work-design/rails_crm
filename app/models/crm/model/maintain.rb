module Crm
  module Model::Maintain
    extend ActiveSupport::Concern

    included do
      attribute :remark, :string
      attribute :position, :integer

      enum :state, {
        init: 'init',
        carted: 'carted',
        ordered: 'ordered'
      }, default: 'init'

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :member, class_name: 'Org::Member', counter_cache: true, inverse_of: :maintains, optional: true
      belongs_to :task_template, class_name: 'Bench::TaskTemplate', optional: true if defined? RailsBench
      belongs_to :profile_agent, class_name: 'Profiled::Profile', foreign_key: :agent_id, optional: true

      has_many :addresses, class_name: 'Profiled::Address', primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:agent_id, :client_id, :contact_id]
      has_many :wallets, class_name: 'Trade::Wallet', primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:agent_id, :client_id, :contact_id]
      has_many :cards, class_name: 'Trade::Card', primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:agent_id, :client_id, :contact_id]
      has_many :carts, class_name: 'Trade::Cart', primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:agent_id, :client_id, :contact_id]
      has_many :orders, class_name: 'Trade::Order', primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:agent_id, :client_id, :contact_id]

      belongs_to :client, optional: true, inverse_of: :maintains
      belongs_to :contact, optional: true, inverse_of: :maintains
      belongs_to :agent, polymorphic: true, inverse_of: :agent_maintains, optional: true
      belongs_to :agency, optional: true
      belongs_to :maintain_source, optional: true
      belongs_to :upstream, class_name: self.name, optional: true
      belongs_to :original, class_name: self.name, optional: true
      has_many :notes, primary_key: [:member_id, :client_id, :contact_id], foreign_key: [:member_id, :client_id, :contact_id]
      has_many :maintain_tags, -> { distinct }, through: :notes

      accepts_nested_attributes_for :client, reject_if: :all_blank
      accepts_nested_attributes_for :profile_agent, reject_if: :all_blank
      accepts_nested_attributes_for :agency, reject_if: :all_blank

      before_validation :sync_pipeline_member, if: -> { task_template_id_changed? }
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
      remark.presence || contact&.name
    end

    def tags
      ids = notes.pluck(:maintain_tag_id).uniq
      MaintainTag.cached.slice(*ids).values
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

  end
end
