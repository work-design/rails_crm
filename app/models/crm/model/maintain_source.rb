module Crm
  module Model::MaintainSource
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :maintains_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :source, optional: true

      validates :name, presence: true

      before_validation do
        self.name ||= source.name if source
      end
    end

  end
end
