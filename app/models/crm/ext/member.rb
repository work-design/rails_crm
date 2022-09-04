module Crm
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      attribute :maintains_count, :integer, default: 0

      has_many :maintains, ->(o) { where(organ_id: o.organ_id) }, class_name: 'Crm::Maintain'
      has_many :profile_clients, through: :maintains
    end

  end
end
