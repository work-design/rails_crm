module Crm
  class Admin::MaintainTagTemplatesController < Admin::BaseController
    before_action :set_maintain_tag_template, only: [:show, :edit, :update, :destroy]

    def index
      @maintain_tag_templates = MaintainTagTemplate.order(sequence: :asc).page(params[:page])
    end

    def new
      @maintain_tag_template = MaintainTagTemplate.new
    end

    def create
      @maintain_tag_template = MaintainTagTemplate.new(maintain_tag_template_params)

      unless @maintain_tag_template.save
        render :new, locals: { model: @maintain_tag_template }, status: :unprocessable_entity
      end
    end

    def show
    end

    def edit
    end

    def update
      @maintain_tag_template.assign_attributes(maintain_tag_template_params)

      unless @maintain_tag_template.save
        render :edit, locals: { model: @maintain_tag_template }, status: :unprocessable_entity
      end
    end

    def destroy
      @maintain_tag_template.destroy
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
end
