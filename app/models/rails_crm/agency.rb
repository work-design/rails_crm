module RailsCrm::Agency
  extend ActiveSupport::Concern
  
  included do
    has_one :maintain, inverse_of: :agency
    has_many :maintains
  end
  
end
