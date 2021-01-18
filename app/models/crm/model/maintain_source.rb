module Crm
  module Model::MaintainSource
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :maintains_count, :integer, default: 0
      belongs_to :organ, optional: true
      belongs_to :maintain_source_template, optional: true

      validates :name, presence: true

      before_validation do
        self.name = maintain_source_template.name if maintain_source_template
      end
    end

  end
end
