module Crm
  class Me::ClientsController < Admin::ClientsController
    include Controller::Me

    def index
      @clients = current_member.agent_clients.page(params[:page])
    end

    private
    def set_new_client
      @client = current_member.agent_clients.build(client_params)
    end
  end
end
