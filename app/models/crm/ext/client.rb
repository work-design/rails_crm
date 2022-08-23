module Crm
  module Ext::Client
    extend ActiveSupport::Concern

    included do
      has_many :agencies, class_name: 'Crm::Agency', inverse_of: :client, dependent: :delete_all
      has_many :agents, through: :agencies

      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_id, inverse_of: :client
      has_many :orders, class_name: 'Trade::Order', foreign_key: :client_id, dependent: :nullify
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :client_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :client_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :client_id, dependent: :nullify

      after_save_commit :sync_user_later, if: -> { account && saved_change_to_identity? }
    end

    def sync_user_later
      ClientSyncUserJob.perform_later(self)
    end

    def sync_client_to_maintains
      client_maintains.each do |maintain|
        maintain.client_user_id ||= account.user_id
        maintain.client_member ||= account.members[0]
        maintain.save
      end
    end

    def sync_client_to_orders
      account.user.orders.where(organ_id: organ_id, client_id: nil).update_all client_id: self.id
      account.user.wallets.where(organ_id: organ_id, client_id: nil).update_all client_id: self.id
      account.user.cards.where(organ_id: organ_id, client_id: nil).update_all client_id: self.id
    end

  end
end
