module Crm
  module Ext::Agent
    extend ActiveSupport::Concern

    included do
      has_many :agencies, class_name: 'Crm::Agency', as: :agent, dependent: :delete_all
      has_many :clients, through: :agencies

      has_many :agent_maintains, class_name: 'Crm::Maintain', as: :agent, inverse_of: :agent
    end

  end
end
