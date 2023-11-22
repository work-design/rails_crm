# frozen_string_literal: true
module Crm
  class Admin::ClientMaintainsController < Admin::BaseController
    include Controller::Admin
    before_action :set_common_maintain

    def index
      @maintains = @client.client_maintains.page(params[:page])
    end


  end
end
