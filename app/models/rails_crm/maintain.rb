module RailsCrm::Maintain
  extend ActiveSupport::Concern
  included do
    attribute :state, :string, default: 'init'
    attribute :note, :string
    attribute :pipeline_id, :integer
    attribute :upstream_id, :integer
    attribute :source_id, :integer
    attribute :position, :integer
    
    belongs_to :member, inverse_of: :maintains, optional: true
    belongs_to :maintain_source, optional: true
    belongs_to :pipeline, optional: true
    belongs_to :pipeline_member, optional: true

    belongs_to :agency, optional: true, inverse_of: :maintain
    belongs_to :client, polymorphic: true, inverse_of: :client_maintains
    belongs_to :agent, polymorphic: true, inverse_of: :agent_maintains, optional: true
    
    belongs_to :upstream, class_name: self.name
    belongs_to :source, class_name: self.name
  
    has_many :maintain_logs, dependent: :delete_all
    has_many :maintain_tags, -> { distinct }, through: :maintain_logs
    has_many :orders, dependent: :nullify
    
    accepts_nested_attributes_for :agency, reject_if: :all_blank
    accepts_nested_attributes_for :agent, reject_if: :all_blank
    accepts_nested_attributes_for :client, reject_if: :all_blank
    
    enum state: {
      init: 'init',
      transferred: 'transferred'
    }
    
    before_validation do
      self.upstream ||= self
      self.source ||= self
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
      m.source = self.source
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
