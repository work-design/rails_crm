module Crm
  class ClientSyncUserJob < ApplicationJob

    def perform(client)
      client.sync_client_to_maintains
      client.sync_client_to_orders
    end

  end
end
