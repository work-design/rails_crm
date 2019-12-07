module RailsCrm::Member
  extend ActiveSupport::Concern

  included do
    has_many :maintains
    has_many :pupils, through: :maintains
  end

end
