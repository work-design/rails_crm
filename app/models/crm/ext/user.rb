module Crm
  module Ext::User
    extend ActiveSupport::Concern

    included do
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_user_id
      has_many :client_contacts, class_name: 'Crm::Contact', foreign_key: :client_user_id
    end

  end
end
