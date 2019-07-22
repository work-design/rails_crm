module RailsCrm::Order
  extend ActiveSupport::Concern
  included do
    attribute :maintain_id, :integer
    belongs_to :maintain, optional: true
  end
  
end
