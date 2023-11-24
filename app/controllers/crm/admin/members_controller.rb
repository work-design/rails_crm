module Crm
  class Admin::MembersController < Admin::BaseController
    before_action :set_client_organ
    before_action :set_member, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_member, only: [:new, :create]

    def index
      @maintains = Maintain.includes(:client_member, :client_organ).where(client_organ_id: params[:client_organ_id]).page(params[:page])
    end

    def show
    end

    def edit_member
      @members = @maintain.client.pending_members
    end

    def init_member
      member = @maintain.client.init_member_organ!
      @maintain.client_member = member
      @maintain.save
    end

    private
    def model_name
      'maintain'
    end

    def set_client_organ
      @client = Org::Organ.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_organ_id]
    end

    def set_member
      @maintain = Maintain.find params[:id]
    end

    def set_new_member
      @maintain = @client.client_maintains.build(maintain_params)
      @maintain.build_client
    end

    def maintain_params
      _p = params.fetch(:maintain, {}).permit(
        :remark,
        client_attributes: [:identity, :nick_name]
      )
      _p.merge! default_form_params
      _p.merge! member_id: current_member.id
    end

  end
end
