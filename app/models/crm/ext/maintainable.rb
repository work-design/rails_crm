module Crm
  module Ext::Maintainable
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain, class_name: 'Crm::Maintain', optional: true

      after_save_commit :sync_maintain_user_later, if: -> { maintain_id.present? && saved_change_to_maintain_id? }
    end

    def sync_maintain_user_later
      OrderMaintainSyncJob.perform_later(self)
    end

    def sync_user_from_maintain
      self.user = maintain.client.users[0]
      self.save
    end

  end
end
