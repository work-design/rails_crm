module Crm
  class ClientSyncUserJob < ApplicationJob

    def perform(profile)
      profile.sync_user
    end

  end
end
