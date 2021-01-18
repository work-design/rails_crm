module Crm
  module Model::Agency
    extend ActiveSupport::Concern

    included do
      has_one :maintain, inverse_of: :agency
      has_many :maintains

      before_validation :sync_from_maintain, if: -> { self.maintain.present? }
    end

    def sync_from_maintain
      self.agent = maintain.agent
      self.client = maintain.client
    end

  end
end
