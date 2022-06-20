module Crm
  module Model::MaintainLog
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :tag_str, :string
      attribute :tag_sequence, :integer
      attribute :extra, :json

      belongs_to :member, class_name: 'Org::Member'

      belongs_to :maintain
      belongs_to :logged, polymorphic: true, optional: true
      belongs_to :maintain_tag, counter_cache: true, optional: true
    end

  end
end
