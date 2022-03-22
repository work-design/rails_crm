module Crm
  class Crm::Panel::QrcodesController < Crm::Panel::BaseController
    before_action :set_source
    before_action :set_new_material, only: [:new, :create]

    def index
      @materials = @source.materials.order(id: :asc)
    end

    private
    def set_source
      @source = Source.find params[:source_id]
    end

    def set_new_material
      @material = @source.build_qrcode(material_params)
    end

    def material_params
      params.fetch(:material, {}).permit(
        :type,
        :picture,
        :note,
        :margin_x,
        :margin_y,
        :font,
        :align,
        :fw,
        :percent
      )
    end
  end
end
