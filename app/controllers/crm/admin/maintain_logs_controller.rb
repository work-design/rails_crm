class Crm::Admin::MaintainLogsController < Crm::Admin::BaseController
  before_action :set_maintain
  before_action :set_maintain_log, only: [:show, :edit, :update, :destroy]
  before_action :prepare_form, only: [:new, :edit]
  
  def index
    @maintain_logs = @maintain.maintain_logs.order(id: :desc).page(params[:page]).per(params[:per])
  end

  def new
    @maintain_log = @maintain.maintain_logs.build
  end

  def create
    @maintain_log = @maintain.maintain_logs.build(maintain_log_params)
    @maintain_log.member_id = current_member.id

    unless @maintain_log.save
      render :new, locals: { model: @maintain_log }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_log.assign_attributes(maintain_log_params)
    
    unless @maintain_log.save
      render :edit, locals: { model: @maintain_log }, status: :unprocessable_entity
    end
  end

  def destroy
    @maintain_log.destroy
  end

  private
  def prepare_form
    @maintain_tags = MaintainTag.default_where(default_params)
  end
  
  def set_maintain
    @maintain = Maintain.find params[:maintain_id]
  end

  def set_maintain_log
    @maintain_log = @maintain.maintain_logs.find(params[:id])
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
