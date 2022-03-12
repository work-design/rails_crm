module Crm
  class Panel::TagsController < Panel::BaseController
    before_action :set_tag, only: [:show, :edit, :update, :destroy]

    def index
      @tags = Tag.order(sequence: :asc).page(params[:page])
    end

    private
    def set_tag
      @tag = Tag.find(params[:id])
    end

    def tag_params
      params.fetch(:tag, {}).permit(
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
