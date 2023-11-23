# frozen_string_literal: true
module Crm
  module Model::Contact
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identity, :string
      attribute :extra, :json, default: {}
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :account, -> { where(confirmed: true) }, class_name: 'Auth::Account', foreign_key: :identity, primary_key: :identity, optional: true

      belongs_to :client, optional: true
      belongs_to :client_member, class_name: 'Org::Member', optional: true

      has_many :pending_members, class_name: 'Org::Member', primary_key: :identity, foreign_key: :identity
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :contact_id, inverse_of: :contact
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :contact_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :contact_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :contact_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :contact_id, dependent: :nullify
      has_many :payment_methods, class_name: 'Trade::PaymentMethod'
      has_many :notes, foreign_key: :contact_id

      has_one_attached :avatar

      after_save :sync_user_to_orders, if: -> { (saved_changes.keys & ['user_id']).present? }
      after_save_commit :sync_user_later, if: -> { account && saved_change_to_identity? }
    end

  end
end
