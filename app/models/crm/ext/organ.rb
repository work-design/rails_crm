module Crm
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_many :maintains, class_name: 'Crm::Maintain', dependent: :nullify
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_organ_id
      has_many :clients, foreign_key: :client_organ_id
    end

    def maintains_count
      maintains.select(:source_id).distinct.count
    end

  end
end
