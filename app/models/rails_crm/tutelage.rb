module RailsCrm::Tutelage
  extend ActiveSupport::Concern
  included do
    has_one :maintain, inverse_of: :tutelage
    has_many :maintains
  end
  
end
