module Crm
  module Ext::WxpayPayment
    extend ActiveSupport::Concern

    included do
      has_many :client_contacts, class_name: 'Crm::Contact', primary_key: [:user_id, :buyer_identifier], foreign_key: []
    end


  end
end
