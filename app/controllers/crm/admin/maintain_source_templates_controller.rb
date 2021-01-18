module Crm
  class Admin::MaintainSourceTemplatesController < Admin::BaseController
    before_action :set_maintain_source_template, only: [:show, :edit, :update, :destroy]

    def index
      @maintain_source_templates = MaintainSourceTemplate.page(params[:page])
    end

    def new
      @maintain_source_template = MaintainSourceTemplate.new
    end

    def create
      @maintain_source_template = MaintainSourceTemplate.new(maintain_source_template_params)

      unless @maintain_source_template.save
        render :new, locals: { model: @maintain_source_template }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @maintain_source_template.assign_attributes(maintain_source_template_params)

      unless @maintain_source_template.save
        render :edit, locals: { model: @maintain_source_template }, status: :unprocessable_entity
      end
    end

    def destroy
      @maintain_source_template.destroy
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
end
