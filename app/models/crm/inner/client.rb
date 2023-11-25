module Crm
  module Inner::Client
    extend ActiveSupport::Concern

    included do
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      has_many :agencies, class_name: 'Crm::Agency', inverse_of: :client, dependent: :delete_all
      has_many :agents, through: :agencies

      has_one :lawful_wallet, class_name: 'Trade::LawfulWallet', foreign_key: :client_id
    end

    def lawful_wallet
      super || create_lawful_wallet
    end

    def xx!
      member = client.init_member_organ!
      self.client_member = member
      self.save
    end

    def sync_user_later
      ClientSyncUserJob.perform_later(self)
    end

    def sync_client_to_maintains
      client_maintains.each do |maintain|
        maintain.client_user_id ||= user_id
        maintain.save
      end
    end

    def sync_user_to_orders
      orders.update_all user_id: client.user_id
      wallets.update_all user_id: client.user_id
      cards.update_all user_id: client.user_id
    end

    def sync_remark_to_user
      if user
        user.name ||= remark
        user.save
      end
    end

  end
end
