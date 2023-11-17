module Crm
  module Model::MaintainLog
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :tag_str, :string
      attribute :tag_sequence, :integer
      attribute :extra, :json

      belongs_to :member, class_name: 'Org::Member'
      belongs_to :client, class_name: 'Profiled::Profile'

      belongs_to :maintain, optional: true
      belongs_to :logged, polymorphic: true, optional: true
      belongs_to :maintain_tag, counter_cache: true, optional: true
    end

  end
end
