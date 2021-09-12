module Crm
  class Admin::MaintainTagTemplatesController < Admin::BaseController
    before_action :set_maintain_tag_template, only: [:show, :edit, :update, :destroy]

    def index
      @maintain_tag_templates = MaintainTagTemplate.order(sequence: :asc).page(params[:page])
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
