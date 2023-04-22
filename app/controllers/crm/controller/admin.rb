module Crm
  module Controller::Admin
    extend ActiveSupport::Concern

    private
    def set_common_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client.account&.user || @maintain.client.users[0] || @maintain.client
    end

    def common_maintain_params
      q = { client_id: @maintain.client_id }
      user = @maintain.client.account&.user || @maintain.client.users[0]
      if user
        q.merge! user_id: @maintain.user.id
      end
      q
    end

  end
end
