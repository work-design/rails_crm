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

    def profile
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
