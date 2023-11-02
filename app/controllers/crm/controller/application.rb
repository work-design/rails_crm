module Crm
  module Controller::Application
    extend ActiveSupport::Concern

    def common_maintain_params
      {
        #maintain_id: @maintain.id,
        client_id: @maintain.client_id,
        user_id: @maintain.client_user_id
      }
    end

    def set_client_user
      if @maintain.client.user
        @client = @maintain.client.user
      else
        @client = @maintain.client
      end
    end

  end
end
