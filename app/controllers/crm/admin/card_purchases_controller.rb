module Crm
  class Admin::CardPurchasesController < Trade::Admin::CardPurchasesController
    before_action :set_maintain
    before_action :set_card
    before_action :set_card_purchase, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @card_purchases = @card.card_purchases.order(last_expire_on: :desc).page(params[:page])
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def set_card
      @card = @client.cards.find params[:card_id]
    end

  end
end
