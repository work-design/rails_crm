module Crm
  module Model::Order
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, optional: true
    end

  end
end
