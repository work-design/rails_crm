module Crm
  module Model::MaintainSource
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :maintains_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :source, optional: true

      validates :name, presence: true, uniqueness: { scope: :organ_id }

      before_validation :init_from_source, if: -> { source_id.present? }
    end

    def init_from_source
      self.name ||= source.name
    end

  end
end
