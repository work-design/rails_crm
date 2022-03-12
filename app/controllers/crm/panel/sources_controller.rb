module Crm
  class Panel::SourcesController < Panel::BaseController

    private
    def source_params
      params.fetch(:source, {}).permit(
        :name,
        :maintains_count
      )
    end

  end
end
