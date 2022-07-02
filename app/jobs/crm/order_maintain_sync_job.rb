module Crm
  class OrderMaintainSyncJob < ApplicationJob

    def perform(order)
      order.sync_user_from_maintain
    end

  end
end
