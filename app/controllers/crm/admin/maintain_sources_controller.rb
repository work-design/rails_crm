class Crm::Admin::MaintainSourcesController < Crm::Admin::BaseController
  before_action :set_maintain_source, only: [:show, :edit, :update, :destroy]

  def index
    q_params = {}
    q_params.merge! default_params
    q_params.merge! params.permit(:name)
    @selected_maintain_sources = MaintainSource.where.not(maintain_source_template_id: nil).default_where(q_params).order(maintain_source_template_id: :asc)
    @maintain_source_templates = MaintainSourceTemplate.order(id: :asc)
    @maintain_sources = MaintainSource.where(maintain_source_template_id: nil).default_where(q_params).page(params[:page])
  end

  def new
    @maintain_source = MaintainSource.new
  end

  def create
    @maintain_source = MaintainSource.new(maintain_source_params)

    unless @maintain_source.save
      render :new, locals: { model: @maintain_source }, status: :unprocessable_entity
    end
  end

  def show
  end

  def edit
  end

  def update
    @maintain_source.assign_attributes(maintain_source_params)

    unless @maintain_source.save
      render :edit, locals: { model: @maintain_source }, status: :unprocessable_entity
    end
  end

  def destroy
    @maintain_source.destroy
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
    p.merge! default_form_params
  end

end
