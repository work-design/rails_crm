module Crm
  class Admin::MembersController < Admin::BaseController
    before_action :set_client_organ
    #before_action :set_client, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @maintains = Maintain.includes(:client_member, :client_organ).where(client_organ_id: params[:client_organ_id]).page(params[:page])
    end

    def show
    end

    private
    def modal_name
      'client'
    end

    def set_client_organ
      @client = Org::Organ.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_organ_id]
    end

  end
end
