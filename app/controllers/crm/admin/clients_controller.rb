module Crm
  class Admin::ClientsController < Admin::BaseController
    before_action :set_client, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_client, only: [:new, :create]

    def index
      @maintains = Maintain.includes(:client, :client_member, :client_organ).where.not(client_member_id: nil).page(params[:page])
    end

    def show
    end

    private
    def modal_name
      'client'
    end

    def set_new_client
      @client = Profiled::Profile.new(client_params)
    end

    def set_client
      @client = Org::Member.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:id]
    end

    def client_params
      _p = params.fetch(:client, {}).permit(
        :identity,
        :nick_name
      )
      _p.merge! default_form_params
    end

  end
end
