#  Rename to Note
module Crm
  module Model::Note
    extend ActiveSupport::Concern

    included do
      attribute :content, :string
      attribute :tag_str, :string
      attribute :tag_sequence, :integer
      attribute :extra, :json

      belongs_to :member, class_name: 'Org::Member'
      belongs_to :client, optional: true
      belongs_to :contact, optional: true

      belongs_to :maintain, primary_key: [:member_id, :client_id, :contanct_id], foreign_key: [:member_id, :client_id, :contact_id], optional: true

      belongs_to :logged, polymorphic: true, optional: true
      belongs_to :maintain_tag, counter_cache: true, optional: true

      has_one_attached :file

      before_validation :sync_client_from_contact, if: -> { contact_id_changed? }
    end

    def sync_client_from_contact
      self.client_id = contact&.client_id
    end

  end
end
