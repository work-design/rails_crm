module RailsCrm::MaintainTagTemplate
  extend ActiveSupport::Concern
  included do
    attribute :sequence, :integer, default: 1
    
    has_many :maintain_tags
  end

end
