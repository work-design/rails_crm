module Crm
  module Model::MaintainTag
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :logged_type, :string  # TimeBooking/Order
      attribute :entity_column, :string # entity_type
      attribute :entity_value, :string # lesson
      attribute :sequence, :integer, default: 1
      attribute :manual, :boolean, default: true
      attribute :color, :string, default: '#2A92CA'
      attribute :notes_count, :integer, default: 0

      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :tag, optional: true

      validates :logged_type, uniqueness: { scope: [:organ_id, :sequence] }, allow_blank: true
      validates :name, presence: true, uniqueness: { scope: :organ_id }

      before_validation :init_from_tag, if: -> { tag_id.present? }
      after_update_commit :delete_default_cache
    end

    def init_from_tag
      self.name = tag.name
      self.color = tag.color
      self.manual = false
    end

    def delete_default_cache
      Rails.cache.delete('maintain_tag')
    end

    class_methods do
      def cached
        Rails.cache.fetch('maintain_tag') do
          MaintainTag.pluck(:id, :name).to_h
        end
      end
    end

  end
end
