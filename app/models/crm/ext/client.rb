module Agential
  module Ext::Client
    extend ActiveSupport::Concern

    included do
      has_many :agencies, class_name: 'Agential::Agency', dependent: :delete_all, inverse_of: :client
      has_many :agents, through: :agencies

      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_id, inverse_of: :client
    end

    def name
      id
    end

  end
end
