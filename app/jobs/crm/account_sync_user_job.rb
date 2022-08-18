module Crm
  class AccountSyncUserJob < ApplicationJob

    def perform(account)
      account.sync_user
    end

  end
end
