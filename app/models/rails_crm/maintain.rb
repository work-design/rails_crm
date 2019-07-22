module RailsCrm::Maintain
  extend ActiveSupport::Concern
  included do
    attribute :state, :string, default: 'init'
    attribute :note, :string
    attribute :pipeline_id, :integer
    
    belongs_to :member, inverse_of: :maintains, optional: true
    belongs_to :maintain_source, optional: true
    belongs_to :pipeline, optional: true
    belongs_to :pipeline_member, optional: true
    
    belongs_to :client, class_name: 'Profile', foreign_key: :client_id, inverse_of: :client_maintains
    belongs_to :tutelar, class_name: 'Profile', foreign_key: :tutelar_id, inverse_of: :tutelar_maintains
    belongs_to :tutelage, optional: true
  
    has_many :maintain_logs, dependent: :delete_all
    has_many :maintain_tags, -> { distinct }, through: :maintain_logs
    has_many :orders, dependent: :nullify
    
    accepts_nested_attributes_for :tutelar, reject_if: :all_blank
    accepts_nested_attributes_for :client, reject_if: :all_blank
    accepts_nested_attributes_for :tutelage, reject_if: :all_blank
    
    enum state: {
      init: 'init',
      transferred: 'transferred'
    }
    
    before_save :sync_pipeline_member, if: -> { pipeline_id_changed? }
  end
  
  def sync_pipeline_member
    self.pipeline_member ||= self.pipeline.pipeline_members.first if self.pipeline
  end
  
  def tags
    ids = maintain_logs.pluck(:maintain_tag_id).uniq
    MaintainTag.cached.slice(*ids).values
  end
  
  def transfer
    next_member = pipeline_member&.next_member
    return if next_member.nil?
    m = Maintain.new
    m.pipeline_member = pipeline_member.next_member
    m.assign_attributes self.attributes.slice('organ_id', 'client_type', 'client_id', 'tutelar_type', 'tutelar_id', 'tutelage_id', 'maintain_source_id', 'pipeline_id')
    self.class.transaction do
      self.update state: 'transferred'
      m.save
    end
    m
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
