module Crm
  module Controller::Application
    extend ActiveSupport::Concern

    def common_maintain_params
      {
        maintain_id: @maintain.id,
        client_id: @maintain.client_id,
        user_id: @maintain.client_user_id
      }
    end

    def set_client_user
      if @maintain.client.user
        return @client = @maintain.client.user
      elsif @maintain.users[0]
        @client = @maintain.users[0] || @maintain.pending_users[0]
      end
      @client = @maintain.client
    end

  end
end
