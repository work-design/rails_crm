module Crm
  module Ext::Client
    extend ActiveSupport::Concern

    included do
      has_many :agencies, class_name: 'Crm::Agency', dependent: :delete_all, inverse_of: :client
      has_many :agents, through: :agencies

      has_many :client_maintains, class_name: 'Crm::Maintain', as: :client, inverse_of: :client
    end

  end
end
