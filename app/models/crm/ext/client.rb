module Crm
  module Ext::Client
    extend ActiveSupport::Concern

    included do
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      belongs_to :client_member, class_name: 'Org::Member', optional: true


      has_many :agencies, class_name: 'Crm::Agency', inverse_of: :client, dependent: :delete_all
      has_many :agents, through: :agencies

      has_many :pending_members, class_name: 'Org::Member', primary_key: :identity, foreign_key: :identity

      has_one :lawful_wallet, class_name: 'Trade::LawfulWallet', foreign_key: :client_id
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_id, inverse_of: :client
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :client_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :client_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :client_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :client_id, dependent: :nullify

      after_save_commit :sync_user_later, if: -> { account && saved_change_to_identity? }
      after_save :sync_user_to_orders, if: -> { (saved_changes.keys & ['user_id']).present? }
    end

    def lawful_wallet
      super || create_lawful_wallet
    end

    def init_member_organ!
      member = pending_members.build
      member.build_organ(name: name)
      member.save!
      member
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
