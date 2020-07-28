module RailsCrm::MaintainTag
  extend ActiveSupport::Concern

  included do
    attribute :name, :string
    attribute :logged_type, :string  # TimeBooking/Order
    attribute :entity_column, :string # entity_type
    attribute :entity_value, :string # lesson
    attribute :sequence, :integer, default: 1
    attribute :manual, :boolean, default: true
    attribute :color, :string, default: '#2A92CA'
    attribute :maintain_logs_count, :integer, default: 0

    belongs_to :organ, optional: true
    belongs_to :maintain_tag_template, optional: true

    validates :logged_type, uniqueness: { scope: [:organ_id, :sequence] }, allow_blank: true
    validates :name, presence: true

    before_validation do
      if maintain_tag_template
        self.name = maintain_tag_template.name
        self.color = maintain_tag_template.color
        self.manual = false
      end
    end
    after_update_commit :delete_default_cache
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
