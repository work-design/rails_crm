module Crm
  class Me::ProductionsController < Admin::ProductionsController
    include Controller::Me
    before_action :set_payment, if: -> { params[:payment_id].present? }

    private
    def set_payment
      @payment = Trade::Payment.find params[:payment_id]
    end

  end
end
