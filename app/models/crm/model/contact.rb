# frozen_string_literal: true
module Crm
  module Model::Contact
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identity, :string
      attribute :extra, :json, default: {}
      attribute :default, :boolean
      attribute :wallets_count, :integer, default: 0
      attribute :cards_count, :integer, default: 0
      attribute :orders_count, :integer, default: 0
      attribute :addresses_count, :integer, default: 0
      attribute :items_count, :integer, default: 0
      attribute :carts_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :account, -> { where(confirmed: true) }, class_name: 'Auth::Account', foreign_key: :identity, primary_key: :identity, optional: true

      belongs_to :client, optional: true
      belongs_to :client_member, ->(o){ where(o.filter_hash) }, class_name: 'Org::Member', optional: true
      belongs_to :client_user, class_name: 'Auth::User', optional: true

      has_many :pending_members, ->(o){ where(o.filter_hash) }, class_name: 'Org::Member', primary_key: :identity, foreign_key: :identity
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :contact_id, inverse_of: :contact
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :contact_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :contact_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :contact_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :contact_id, dependent: :nullify
      has_many :carts, class_name: 'Trade::Cart', primary_key: [:id, :client_id], query_constraints: [:contact_id, :client_id]
      has_many :items, class_name: 'Trade::Item', foreign_key: :contact_id
      has_many :payment_methods, class_name: 'Trade::PaymentMethod'
      has_many :notes, foreign_key: :contact_id

      accepts_nested_attributes_for :client_maintains

      has_one_attached :avatar

      validates :identity, uniqueness: { scope: [:client_id] }

      after_save :sync_member_to_orders, if: -> { (saved_changes.keys & ['client_member_id']).present? }
      after_save :sync_user_to_orders, if: -> { (saved_changes.keys & ['client_user_id']).present? }
      after_update :set_default, if: -> { default? && saved_change_to_default? }
      after_save_commit :sync_user_later, if: -> { account && saved_change_to_identity? }
    end

    def set_default
      self.class.where.not(id: self.id).where(organ_id: self.organ_id, client_id: self.client_id).update_all(default: false)
    end

    def filter_hash
      if client&.client_organ_id
        { organ_id: client.client_organ_id }
      else
        {}
      end
    end

    def init_member_organ!
      member = build_client_member(identity: identity)
      member.save!
      member
    end

    def sync_member_to_orders
      orders.update_all member_id: client_member_id, member_organ_id: client&.client_organ_id
      wallets.update_all member_id: client_member_id, member_organ_id: client&.client_organ_id
      cards.update_all member_id: client_member_id, member_organ_id: client&.client_organ_id
      carts.update_all member_id: client_member_id, member_organ_id: client&.client_organ_id
    end

    def sync_user_to_orders
      orders.update_all user_id: client_user_id
      wallets.update_all user_id: client_user_id
      cards.update_all user_id: client_user_id
    end

    def sync_user_later
      #ClientSyncUserJob.perform_later(self)
    end

  end
end
