module Crm
  module Controller::Application
    extend ActiveSupport::Concern

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
