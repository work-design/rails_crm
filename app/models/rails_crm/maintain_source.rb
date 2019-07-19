module RailsCrm::MaintainSource
  extend ActiveSupport::Concern
  included do
    belongs_to :organ
    belongs_to :maintain_source_template, optional: true
    
    validates :name, presence: true
    
    before_validation do
      self.name = maintain_source_template.name if maintain_source_template
    end
  end
  
end
