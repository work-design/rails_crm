module Crm
  class Panel::SourcesController < Panel::BaseController

    private
    def source_params
      params.fetch(:source, {}).permit(
        :name,
        :price,
        :logo
      )
    end

  end
end