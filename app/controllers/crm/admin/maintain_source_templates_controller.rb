module Crm
  class Admin::MaintainSourceTemplatesController < Admin::BaseController

    private
    def maintain_source_template_params
      params.fetch(:maintain_source_template, {}).permit(
        :name,
        :maintains_count
      )
    end

  end
end
