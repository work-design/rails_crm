class Crm::Admin::MaintainSourceTemplatesController < Crm::Admin::BaseController
  before_action :set_maintain_source_template, only: [:show, :edit, :update, :destroy]

  def index
    @maintain_source_templates = MaintainSourceTemplate.page(params[:page])
  end

  def new
    @maintain_source_template = MaintainSourceTemplate.new
  end

  def create
    @maintain_source_template = MaintainSourceTemplate.new(maintain_source_template_params)

    respond_to do |format|
      if @maintain_source_template.save
        format.html.phone
        format.html { redirect_to admin_maintain_source_templates_url }
        format.js { redirect_back fallback_location: admin_maintain_source_templates_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: admin_maintain_source_templates_url }
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_source_template.assign_attributes(maintain_source_template_params)

    respond_to do |format|
      if @maintain_source_template.save
        format.html.phone
        format.html { redirect_to admin_maintain_source_templates_url }
        format.js { redirect_back fallback_location: admin_maintain_source_templates_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_maintain_source_templates_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @maintain_source_template.destroy
    redirect_to admin_maintain_source_templates_url
  end

  private
  def set_maintain_source_template
    @maintain_source_template = MaintainSourceTemplate.find(params[:id])
  end

  def maintain_source_template_params
    params.fetch(:maintain_source_template, {}).permit(
      :name,
      :maintains_count
    )
  end

end
