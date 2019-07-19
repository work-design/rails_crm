module RailsCrm::MaintainTagTemplate
  extend ActiveSupport::Concern
  included do
    has_many :maintain_tags
  end

end
