module Crm
  class Admin::Client::ClientsController < Admin::ClientsController
    before_action :set_parent
    before_action :set_new_client, only: [:new, :create]

    def index
      @clients = @client.children.page(params[:page])
    end

    private
    def set_parent
      @client = Client.find params[:client_id]
    end

    def set_new_client
      @client = @client.children.build(client_params)
    end

    def client_params
      _p = params.fetch(:client, {}).permit(
        :name,
        :vendor,
        :client_organ_id,
        settings: {}
      )
      _p.merge! default_form_params
    end

  end
end
