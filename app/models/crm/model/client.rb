# frozen_string_literal: true

module Crm
  module Model::Client
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :settings, :json, default: {}
      attribute :vendor, :boolean
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true # warehouse
      belongs_to :client_organ, class_name: 'Org::Organ', optional: true # shop join in

      has_many :contacts
      has_many :members, class_name: 'Contact', foreign_key: :client_id
      #has_many :children, class_name: self.name

      has_one :lawful_wallet, class_name: 'Trade::LawfulWallet', foreign_key: :client_id
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_id, inverse_of: :client
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :client_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :client_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :client_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :client_id, dependent: :nullify
      has_many :payment_methods, class_name: 'Trade::PaymentMethod', foreign_key: :client_id

      has_many :notes, foreign_key: :client_id

      has_many :agencies, class_name: 'Crm::Agency', inverse_of: :client, dependent: :delete_all
      has_many :agents, through: :agencies
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

    def form_settings
      RailsCom::Setting.new(settings)
    end

  end
end
