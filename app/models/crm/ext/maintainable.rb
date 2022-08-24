module Crm
  module Ext::Maintainable
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, class_name: 'Crm::Maintain', counter_cache: true, optional: true
      belongs_to :client, class_name: 'Profiled::Profile', optional: true

      before_save :sync_from_maintain, if: -> { maintain_id.present? && maintain_id_changed? }
      after_create :change_maintain_state, if: -> { maintain_id.present? && saved_change_to_maintain_id? }
    end

    def sync_from_maintain
      return unless maintain
      self.client_id = maintain.client_id
      self.user_id = maintain.client_user_id
      self.member_id = maintain.client_member_id
    end

    def change_maintain_state
      return unless maintain
      maintain.update state: 'ordered'
    end

  end
end
