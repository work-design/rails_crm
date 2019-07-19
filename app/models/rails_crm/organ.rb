module RailsCrm::Organ
  extend ActiveSupport::Concern
  included do
    has_many :maintains, dependent: :nullify
    has_many :pupils, through: :maintains
  end
  
end
