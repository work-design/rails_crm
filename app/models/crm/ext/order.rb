module Crm
  module Ext::Order
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, class_name: 'Crm::Maintain', optional: true
    end

  end
end
