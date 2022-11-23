module Crm
  class Admin::MaintainSourcesController < Admin::BaseController
    before_action :set_maintain_source, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_maintain_source, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:name)

      @maintain_sources = MaintainSource.includes(:source).default_where(q_params).page(params[:page])
    end

    def templates
      @maintain_source_templates = Source.order(id: :asc)
      @selected_maintain_sources = MaintainSource.where.not(maintain_source_template_id: nil).default_where(q_params).order(maintain_source_template_id: :asc)
    end

    private
    def set_maintain_source
      @maintain_source = MaintainSource.find(params[:id])
    end

    def set_new_maintain_source
      @maintain_source = MaintainSource.new(maintain_source_params)
    end

    def maintain_source_params
      p = params.fetch(:maintain_source, {}).permit(
        :name,
        :maintain_source_template_id
      )
      p.merge! default_form_params
    end

  end
end
