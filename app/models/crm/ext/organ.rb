module Crm
  module Ext::Organ
    extend ActiveSupport::Concern

    included do
      has_many :maintains, class_name: 'Crm::Maintain', dependent: :nullify
      has_many :clients, through: :maintains
    end

    def maintains_count
      maintains.select(:source_id).distinct.count
    end

  end
end
