module Crm
  module Ext::Maintainable
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, class_name: 'Crm::Maintain', optional: true

      before_save :sync_user_from_maintain, if: -> { maintain_id.present? && maintain_id_changed? }
      after_create :change_maintain_state, if: -> { maintain_id.present? && saved_change_to_maintain_id? }
    end

    def sync_user_from_maintain
      return unless maintain
      self.user = maintain.client_user_id
      self.member = maintain.client_member_id
    end

    def change_maintain_state
      return unless maintain
      maintain.update state: 'ordered'
    end

  end
end
