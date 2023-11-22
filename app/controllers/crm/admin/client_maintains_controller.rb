# frozen_string_literal: true
module Crm
  class Admin::ClientMaintainsController < Admin::BaseController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_maintain, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_maintain, only: [:new, :create]

    def index
      @maintains = @client.client_maintains.page(params[:page])
    end

    private
    def model_name
      'maintain'
    end

    def set_maintain
      @maintain = Maintain.find params[:id]
    end

    def set_new_maintain
      @maintain = @client.client_maintains.build(maintain_params)
    end

    def maintain_params
      params.fetch(:maintain, {}).permit(
        :remark
      )
    end

  end
end
