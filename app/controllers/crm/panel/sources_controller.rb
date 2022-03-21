module Crm
  class Panel::SourcesController < Panel::BaseController

    def index
      q_params = {}
      q_params.merge! params.permit(:name)

      @sources = Source.roots.default_where(q_params).page(params[:page])
    end

    private
    def source_params
      params.fetch(:source, {}).permit(
        :name,
        :price,
        :logo,
        :parent_ancestors
      )
    end

  end
end
