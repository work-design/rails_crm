module Crm
  class Crm::Panel::MaterialsController < Crm::Panel::BaseController
    before_action :set_source
    before_action :set_new_material, only: [:new, :create]

    def index
      @materials = @source.materials

      @primary_material = @source.materials.find(&->(i){ i.is_a?(PrimaryMaterial) })
    end

    private
    def set_source
      @source = Source.find params[:source_id]
    end

    def set_new_material
      @material = @source.materials.build(material_params)
    end

    def material_params
      params.fetch(:material, {}).permit(
        :type,
        :picture,
        :note,
        :margin_x,
        :margin_y,
        :font,
        :align
      )
    end
  end
end
