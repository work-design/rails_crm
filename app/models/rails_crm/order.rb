module RailsCrm::Order
  extend ActiveSupport::Concern
  
  included do
    belongs_to :maintain, optional: true
  end
  
end
