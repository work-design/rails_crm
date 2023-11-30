module Crm
  class Admin::Client::ClientsController < Admin::ClientsController
    before_action :set_client

    def index
      @clients = @client.children.page(params[:page])
    end

    private
    def set_client
      @client = Client.find params[:client_id]
    end
  end
end
