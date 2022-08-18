module Crm
  class Me::MaintainsController < Admin::MaintainsController
    include Controller::Me
    before_action :set_maintain, only: [:show, :edit, :update, :destroy, :actions]

    def index
      q_params = {}
      q_params.merge! params.permit(:state, 'remark-like')

      @maintains = current_member.maintains.includes(:client).default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:id]
    end

  end
end
