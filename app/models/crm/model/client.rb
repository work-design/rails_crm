# frozen_string_literal: true

module Crm
  module Model::Client
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :settings, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true # warehouse
      belongs_to :client_organ, class_name: 'Org::Organ', optional: true # shop join in

      has_many :contacts
      #has_many :children, class_name: self.name

      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_id, inverse_of: :client
      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :client_id, dependent: :nullify
      has_many :cards, class_name: 'Trade::Card', foreign_key: :client_id, dependent: :nullify
      has_many :orders, class_name: 'Trade::Order', foreign_key: :client_id, dependent: :nullify
      has_many :wallets, class_name: 'Trade::Wallet', foreign_key: :client_id, dependent: :nullify
      has_many :payment_methods, class_name: 'Trade::PaymentMethod', foreign_key: :client_id

      has_many :notes, foreign_key: :client_id
    end

  end
end
