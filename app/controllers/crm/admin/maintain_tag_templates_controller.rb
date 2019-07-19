class Crm::Admin::MaintainTagTemplatesController < Crm::Admin::BaseController
  before_action :set_maintain_tag_template, only: [:show, :edit, :update, :destroy]

  def index
    @maintain_tag_templates = MaintainTagTemplate.order(sequence: :asc).page(params[:page])
  end

  def new
    @maintain_tag_template = MaintainTagTemplate.new
  end

  def create
    @maintain_tag_template = MaintainTagTemplate.new(maintain_tag_template_params)

    respond_to do |format|
      if @maintain_tag_template.save
        format.html.phone
        format.html { redirect_to admin_maintain_tag_templates_url }
        format.js { redirect_back fallback_location: admin_maintain_tag_templates_url }
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js { redirect_back fallback_location: admin_maintain_tag_templates_url }
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_tag_template.assign_attributes(maintain_tag_template_params)

    respond_to do |format|
      if @maintain_tag_template.save
        format.html.phone
        format.html { redirect_to admin_maintain_tag_templates_url }
        format.js { redirect_back fallback_location: admin_maintain_tag_templates_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_maintain_tag_templates_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @maintain_tag_template.destroy
    redirect_to admin_maintain_tag_templates_url
  end

  private
  def set_maintain_tag_template
    @maintain_tag_template = MaintainTagTemplate.find(params[:id])
  end

  def maintain_tag_template_params
    params.fetch(:maintain_tag_template, {}).permit(
      :name,
      :logged_type,
      :entity_column,
      :entity_value,
      :sequence,
      :color
    )
  end

end
