module Crm
  class Admin::MaintainLogsController < Admin::BaseController
    before_action :set_maintain
    before_action :set_maintain_log, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_maintain_log, only: [:new, :create]
    before_action :set_maintain_tags, only: [:new, :edit]

    def index
      @maintain_logs = @maintain.maintain_logs.order(id: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_maintain_tags
      @maintain_tags = MaintainTag.default_where(default_params)
    end

    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_maintain_log
      @maintain_log = @maintain.maintain_logs.find(params[:id])
    end

    def set_new_maintain_log
      @maintain_log = @maintain.maintain_logs.build(maintain_log_params)
      @maintain_log.member = current_member
    end

    def maintain_log_params
      params.fetch(:maintain_log, {}).permit(
        :maintain_tag_id,
        :note,
        :logged_type,
        :logged_id
      )
    end

  end
end
