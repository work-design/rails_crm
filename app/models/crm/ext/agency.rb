module Crm
  module Ext::Agency
    extend ActiveSupport::Concern

    included do
      has_one :maintain, class_name: 'Crm::Maintain', inverse_of: :agency
      has_many :maintains, class_name: 'Crm::Maintain'

      before_validation :sync_from_maintain, if: -> { self.maintain.present? }
    end

    def sync_from_maintain
      self.agent = maintain.agent
      self.client = maintain.client
    end

  end
end
