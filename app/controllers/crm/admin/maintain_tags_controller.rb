module Crm
  class Admin::MaintainTagsController < Admin::BaseController
    before_action :set_maintain_tag, only: [:show, :edit, :update, :destroy]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:name)

      @maintain_tags = MaintainTag.where(tag_id: nil).default_where(q_params).page(params[:page])
      @selected_maintain_tags = MaintainTag.where.not(tag_id: nil).default_where(q_params).order(tag_id: :asc)
      @tags = Tag.order(id: :asc)
    end

    def new
      @maintain_tag = MaintainTag.new
    end

    def create
      @maintain_tag = MaintainTag.new(maintain_tag_params)

      unless @maintain_tag.save
        render :new, locals: { model: @maintain_tag }, status: :unprocessable_entity
      end
    end

    def sync
      q_params = default_params
      MaintainTag.default_where(q_params).sync_from_template
    end

    private
    def set_maintain_tag
      @maintain_tag = MaintainTag.find(params[:id])
    end

    def maintain_tag_params
      p = params.fetch(:maintain_tag, {}).permit(
        :name,
        :sequence,
        :color,
        :logged_type
      )
      p.merge! default_form_params
    end

  end
end
