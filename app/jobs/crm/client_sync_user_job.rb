module Crm
  class ClientSyncUserJob < ApplicationJob

    def perform(client)
      client.sync_user
    end

  end
end
