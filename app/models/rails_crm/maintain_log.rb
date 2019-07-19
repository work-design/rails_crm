module RailsCrm::MaintainLog
  extend ActiveSupport::Concern
  included do
    attribute :note, :string
    attribute :tag_str, :string
    attribute :tag_sequence, :integer
  
    belongs_to :maintain
    belongs_to :member
    belongs_to :logged, polymorphic: true, optional: true
    belongs_to :maintain_tag, counter_cache: true, optional: true
  end
  
end
