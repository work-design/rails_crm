module Crm
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      has_many :maintains, class_name: 'Crm::Maintain'
      has_many :clients, through: :maintains
    end

  end
end
