module Crm
  module Model::Maintain
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :position, :integer

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :member, class_name: 'Org::Member', inverse_of: :maintains, optional: true
      belongs_to :task_template, class_name: 'Bench::TaskTemplate', optional: true
      belongs_to :agency, class_name: 'Agential::Agency', optional: true, inverse_of: :maintain
      belongs_to :client, class_name: 'Profiled::Profile', inverse_of: :client_maintains
      belongs_to :agent, class_name: 'Auth::User', inverse_of: :agent_maintains, optional: true

      belongs_to :maintain_source, optional: true
      belongs_to :upstream, class_name: self.name
      belongs_to :original, class_name: self.name

      has_many :maintain_logs, dependent: :delete_all
      has_many :maintain_tags, -> { distinct }, through: :maintain_logs
      has_many :orders, dependent: :nullify

      accepts_nested_attributes_for :agency, reject_if: :all_blank
      accepts_nested_attributes_for :agent, reject_if: :all_blank
      accepts_nested_attributes_for :client, reject_if: :all_blank

      enum state: {
        init: 'init',
        transferred: 'transferred'
      }, _default: 'init'

      before_validation do
        self.upstream ||= self
        self.original ||= self
        self.position = self.pipeline_member&.position
      end
      before_save :sync_pipeline_member, if: -> { pipeline_id_changed? }
    end

    def sync_pipeline_member
      self.pipeline_member ||= self.pipeline.pipeline_members.first if self.pipeline
    end

    def tags
      ids = maintain_logs.pluck(:maintain_tag_id).uniq
      MaintainTag.cached.slice(*ids).values
    end

    def transfer!
      self.state = 'transferred'

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
