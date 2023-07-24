module Crm
  module Ext::Account
    extend ActiveSupport::Concern

    included do
      after_save_commit :sync_user_later, if: -> { saved_change_to_user_id? }
    end

    def sync_user_later
      AccountSyncUserJob.perform_later(self)
    end

    def sync_user
      profiles.each do |profile|
        profile.user_id ||= user_id
        profile.client_maintains.each do |maintain|
          maintain.client_user_id ||= user_id
          maintain.client_member ||= members[0]
          maintain.save
        end
      end
    end

  end
end
