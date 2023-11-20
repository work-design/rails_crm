module Crm
  class Admin::ClientsController < Admin::BaseController
    before_action :set_client, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @maintains = Maintain.includes(:client, :client_member, :client_organ).where.not(client_member_id: nil).page(params[:page])
    end

    def show
    end

    private
    def modal_name
      'client'
    end

    def set_client
      @client = Org::Member.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:id]
    end

  end
end
