module Crm
  class Admin::CardPurchasesController < Trade::Admin::CardPurchasesController

    def index
      @card_purchases = @card.card_purchases.order(last_expire_on: :desc).page(params[:page])
    end

    private

  end
end
