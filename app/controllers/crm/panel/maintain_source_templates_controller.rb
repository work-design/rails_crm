module Crm
  class Panel::MaintainSourceTemplatesController < Panel::BaseController

    private
    def maintain_source_template_params
      params.fetch(:maintain_source_template, {}).permit(
        :name,
        :maintains_count
      )
    end

  end
end
