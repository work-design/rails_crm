module Crm
  module Ext::Member
    extend ActiveSupport::Concern

    included do
      attribute :maintains_count, :integer, default: 0

      has_many :maintains, ->(o) { where(organ_id: o.organ_id) }, class_name: 'Crm::Maintain'
      has_many :client_maintains, class_name: 'Crm::Maintain', foreign_key: :client_member_id
      has_many :profile_clients, through: :maintains

      has_many :addresses, class_name: 'Profiled::Address', foreign_key: :member_id
    end

  end
end
