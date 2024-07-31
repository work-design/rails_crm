# frozen_string_literal: true

module Crm
  module Model::Client
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :settings, :json, default: {}
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :client_organ, class_name: 'Org::Organ', optional: true
      has_many :members, class_name: 'Contact', foreign_key: :client_id
      #has_many :children, class_name: self.name

      has_one :lawful_wallet, class_name: 'Trade::LawfulWallet', foreign_key: :client_id
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :client_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :client_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :client_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :client_id, dependent: :nullify
      has_many :carts, class_name: 'Trade::Cart', foreign_key: :client_id, dependent: :nullify
      has_many :payment_methods, class_name: 'Trade::PaymentMethod', foreign_key: :client_id, dependent: :nullify

      has_many :contacts
      has_many :notes
      has_many :maintains

      has_many :agencies, class_name: 'Crm::Agency', inverse_of: :client, dependent: :delete_all
      has_many :agents, through: :agencies

      validates :name, uniqueness: { scope: :organ_id }

      after_save :sync_organ_to_orders, if: -> { (saved_changes.keys & ['client_organ_id']).present? }
    end

    def lawful_wallet
      super || create_lawful_wallet
    end

    def xx!
      member = client.init_member_organ!
      self.client_member = member
      self.save
    end

    def sync_remark_to_user
      if user
        user.name ||= remark
        user.save
      end
    end

    def init_client_organ
      self.build_client_organ(name: name)
    end

    def sync_organ_to_orders
      orders.update_all member_organ_id: client_organ_id
      wallets.update_all member_organ_id: client_organ_id
      cards.update_all member_organ_id: client_organ_id
      carts.update_all member_organ_id: client_organ_id
    end

    def form_settings
      RailsCom::Setting.new(settings)
    end

  end
end
