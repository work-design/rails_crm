module Crm
  class Me::MaintainsController < Admin::MaintainsController
    include Controller::Me
    before_action :set_maintain, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_client, only: [:client, :create_client]

    def index
      q_params = {}
      q_params.merge! params.permit(:state, 'remark-like')

      @maintains = current_member.maintains.includes(:client).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def show
      @client = @maintain.client
    end

    def client
      @maintain = current_member.maintains.find_by(client_id: params[:client_id])
    end

    def create_client
      @maintain = current_member.maintains.find_or_initialize_by(client_id: params[:client_id])
      @maintain.save
    end

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:id]
    end

    def set_client
      @client = Profiled::Profile.find params[:client_id]
    end

  end
end
