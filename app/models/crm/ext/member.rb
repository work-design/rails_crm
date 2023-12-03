module Crm
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      attribute :maintains_count, :integer, default: 0

      has_many :maintains, class_name: 'Crm::Maintain'
      has_many :agent_contacts, class_name: 'Crm::Contact', through: :maintains, source: :contact
      has_many :agent_clients, class_name: 'Crm::Client', through: :maintains, source: :client

      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_member_id
      has_many :client_contacts, class_name: 'Crm::Contact', foreign_key: :client_member_id
    end

  end
end
