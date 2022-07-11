module Crm
  module Ext::Maintainable
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, class_name: 'Crm::Maintain', optional: true

      after_save_commit :sync_user_from_maintain, :change_maintain_state, if: -> { maintain_id.present? && saved_change_to_maintain_id? }
    end

    def sync_user_from_maintain
      return unless maintain
      self.user = maintain.client.users[0]
      self.member = maintain.client.members[0]
      self.save
    end

    def change_maintain_state
      return unless maintain
      maintain.update state: 'ordered'
    end

  end
end
