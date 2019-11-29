module RailsCrm::MaintainTagTemplate
  extend ActiveSupport::Concern
  included do
    attribute :name, :string
    attribute :logged_type, :string
    attribute :entity_column, :string
    attribute :entity_value, :string
    attribute :color, :string
    attribute :sequence, :integer, default: 1
    
    has_many :maintain_tags
  end

end
