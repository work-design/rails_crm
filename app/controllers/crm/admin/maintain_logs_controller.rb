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

    respond_to do |format|
      if @maintain_log.save
        format.html.phone
        format.html { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.js { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_log.assign_attributes(maintain_log_params)

    respond_to do |format|
      if @maintain_log.save
        format.html.phone
        format.html { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.js { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_to admin_maintain_maintain_logs_url(@maintain) }
        format.json { render :show }
      end
    end
  end

  def destroy
    @maintain_log.destroy
    redirect_to admin_maintain_maintain_logs_url(@maintain)
  end

  private
  def prepare_form
    @maintain_tags = MaintainTag.default_where(organ_ancestors_params)
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
