module Crm
  class Crm::Panel::TextsController < Crm::Panel::BaseController
    before_action :set_source
    before_action :set_new_text, only: [:new, :create]

    def index
      @texts = @source.texts.order(id: :asc)
    end

    private
    def set_source
      @source = Source.find params[:source_id]
    end

    def set_new_text
      @text = @source.texts.build(text_params)
    end

    def text_params
      params.fetch(:text, {}).permit(
        :note,
        :margin_x,
        :margin_y,
        :font,
        :align
      )
    end
  end
end
