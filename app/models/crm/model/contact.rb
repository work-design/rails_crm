# frozen_string_literal: true
module Crm
  module Model::Contact
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :identity, :string
      attribute :extra, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :account, -> { where(confirmed: true) }, class_name: 'Auth::Account', foreign_key: :identity, primary_key: :identity, optional: true

      belongs_to :client

      has_one_attached :avatar

      after_save :sync_user_to_orders, if: -> { (saved_changes.keys & ['user_id']).present? }
      after_save_commit :sync_user_later, if: -> { account && saved_change_to_identity? }
    end

  end
end
