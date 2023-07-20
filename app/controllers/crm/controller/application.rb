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
      if @maintain.client_user
        return @client = @maintain.client_user
      else
        user = @maintain.users[0] || @maintain.pending_users[0]
        if user
          @maintain.update client_user_id: user.id
          return @client = user
        end
      end
      @client = @maintain.client
    end

  end
end
