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
      belongs_to :client_member, ->(o){ where(o.filter_hash) }, class_name: 'Org::Member', optional: true
      belongs_to :client_user, class_name: 'Auth::User', optional: true

      has_many :pending_members, ->(o){ where(o.filter_hash) }, class_name: 'Org::Member', primary_key: :identity, foreign_key: :identity
      has_many :addresses, class_name: 'Ship::Address', foreign_key: :contact_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :contact_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :contact_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :contact_id, dependent: :nullify
      has_many :lawful_wallets, class_name: 'Trade::LawfulWallet', foreign_key: :contact_id, dependent: :nullify
      has_many :custom_wallets, class_name: 'Trade::CustomWallet', foreign_key: :contact_id, dependent: :nullify
      has_many :carts, class_name: 'Trade::Cart', primary_key: [:id, :client_id], foreign_key: [:contact_id, :client_id]
      has_many :items, class_name: 'Trade::Item', foreign_key: :contact_id
      has_many :payment_methods, class_name: 'Trade::PaymentMethod'

      belongs_to :client, optional: true
      has_many :maintains
      has_many :notes

      accepts_nested_attributes_for :maintains

      has_one_attached :avatar

      validates :identity, uniqueness: { scope: [:client_id, :organ_id] }, allow_nil: true

      before_save :sync_from_client_user, if: -> { client_user_id_changed? && client_user }
      after_save :sync_member_to_orders, if: -> { (saved_changes.keys & ['client_member_id']).present? }
      after_save :sync_user_to_orders, if: -> { client_user_id && (saved_changes.keys & ['client_user_id']).present? }
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

    def enter_url
      Rails.application.routes.url_for(
        controller: 'crm/contacts',
        action: 'qrcode',
        id: id
      )
    end

    def bind_path
      Rails.application.routes.url_for(
        controller: 'crm/my/contacts',
        action: 'bind',
        id: id,
        only_path: true
      )
    end

    def qrcode_bind_url
      bind_url = Rails.application.routes.url_for(
        controller: 'crm/my/contacts',
        action: 'bind',
        id: id,
        host: organ.host
      )
      QrcodeHelper.data_url(bind_url)
    end

    def qrcode_enter_png
      QrcodeHelper.code_png(enter_url, border_modules: 0, fill: 'pink')
    end

    def qrcode_enter_url
      QrcodeHelper.data_url(enter_url)
    end

    def sync_from_client_user
      self.name = client_user.name if self.name.blank?
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
      orders.where(user_id: nil).update_all user_id: client_user_id
      wallets.where(user_id: nil).update_all user_id: client_user_id
      cards.where(user_id: nil).update_all user_id: client_user_id

      client_user.cards.where(organ_id: organ_id, contact_id: nil).update_all contact_id: id
      client_user.orders.where(organ_id: organ_id, contact_id: nil).update_all contact_id: id
      client_user.wallets.where(organ_id: organ_id, contact_id: nil).update_all contact_id: id
    end

    def sync_user_later
      #ClientSyncUserJob.perform_later(self)
    end

  end
end
