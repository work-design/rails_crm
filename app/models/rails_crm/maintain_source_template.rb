module RailsCrm::MaintainSourceTemplate
  extend ActiveSupport::Concern
  included do
    has_many :maintain_sources
  end
  
end
