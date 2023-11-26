module Crm
  class Admin::Client::AddressesController < Admin::AddressesController
    before_action :set_client

    private
    def set_client
      @client = Client.find params[:client_id]
    end
  end
end
