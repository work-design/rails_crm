module Crm
  class Admin::Client::ProductionsController < Admin::ProductionsController
    before_action :set_client

    private
    def set_client
      @client = Client.find params[:client_id]
    end
  end
end
