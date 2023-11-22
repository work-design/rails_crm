# frozen_string_literal: true

module Crm
  module Model::ContactOrgan
    extend ActiveSupport::Concern

    included do
      attribute :settings, :json, default: {}

      belongs_to :organ, class_name: 'Org::Organ', optional: true
      belongs_to :client_organ, class_name: 'Org::Organ', optional: true
    end

  end
end
