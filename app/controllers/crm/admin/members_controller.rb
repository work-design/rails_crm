module Crm
  class Admin::MembersController < Admin::BaseController
    before_action :set_client_organ
    #before_action :set_client, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_member, only: [:new, :create]

    def index
      @maintains = Maintain.includes(:client_member, :client_organ).where(client_organ_id: params[:client_organ_id]).page(params[:page])
    end

    def show
    end

    private
    def modal_name
      'member'
    end

    def set_client_organ
      @client = Org::Organ.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_organ_id]
    end

    def set_new_member
      @member = @client.members.build(member_params)
    end

    def member_params
      params.fetch(:member, {}).permit(
        :identity,
        :name
      )
    end

  end
end
