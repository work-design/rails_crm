class Crm::Admin::MaintainSourcesController < Crm::Admin::BaseController
  before_action :set_maintain_source, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! organ_ancestors_params
    q_params.merge! params.permit(:name)
    @maintain_sources = MaintainSource.where(maintain_source_template_id: nil).default_where(q_params).page(params[:page])
    @selected_maintain_sources = MaintainSource.where.not(maintain_source_template_id: nil).default_where(q_params).order(maintain_source_template_id: :asc)
    @maintain_source_templates = MaintainSourceTemplate.order(id: :asc)
  end

  def new
    @maintain_source = MaintainSource.new
  end

  def create
    @maintain_source = MaintainSource.new(maintain_source_params)

    respond_to do |format|
      if @maintain_source.save
        format.html.phone
        format.html { redirect_to admin_maintain_sources_url }
        format.js
        format.json { render :show }
      else
        format.html.phone { render :new }
        format.html { render :new }
        format.js
        format.json { render :show }
      end
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_source.assign_attributes(maintain_source_params)

    respond_to do |format|
      if @maintain_source.save
        format.html.phone
        format.html { redirect_to admin_maintain_sources_url }
        format.js { redirect_back fallback_location: admin_maintain_sources_url }
        format.json { render :show }
      else
        format.html.phone { render :edit }
        format.html { render :edit }
        format.js { redirect_back fallback_location: admin_maintain_sources_url }
        format.json { render :show }
      end
    end
  end

  def destroy
    @maintain_source.destroy
    redirect_to admin_maintain_sources_url
  end

  private
  def set_maintain_source
    @maintain_source = MaintainSource.find(params[:id])
  end

  def maintain_source_params
    p = params.fetch(:maintain_source, {}).permit(
      :name,
      :maintain_source_template_id
    )
    p.merge! default_params
  end

end
