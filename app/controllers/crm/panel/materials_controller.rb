module Crm
  class Crm::Panel::MaterialsController < Crm::Panel::BaseController
    before_action :set_tag
    before_action :set_new_material, only: [:new, :create]

    private
    def set_tag
      @tag = Tag.find params[:tag_id]
    end

    def set_new_material
      @material = @tag.materials.build(material_params)
    end

    def material_params
      params.fetch(:material, {}).permit(
        :picture
      )
    end
  end
end
