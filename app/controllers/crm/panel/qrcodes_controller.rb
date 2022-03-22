module Crm
  class Crm::Panel::QrcodesController < Crm::Panel::BaseController
    before_action :set_source
    before_action :set_new_qrcode, only: [:new, :create]

    def index
      @qrcodes = @source.qrcodes.order(id: :asc)
    end

    private
    def set_source
      @source = Source.find params[:source_id]
    end

    def set_new_qrcode
      @qrcode = @source.build_qrcode(qrcode_params)
    end

    def qrcode_params
      params.fetch(:qrcode, {}).permit(
        :margin_x,
        :margin_y,
        :align,
        :fixed_width,
        :picture
      )
    end
  end
end
