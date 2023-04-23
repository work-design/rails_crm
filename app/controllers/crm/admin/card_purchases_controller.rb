module Crm
  class Admin::CardPurchasesController < Trade::Admin::CardPurchasesController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_card
    before_action :set_card_purchase, only: [:show, :edit, :update, :destroy, :actions]

    private
    def set_card
      @card = @client.cards.find params[:card_id]
    end

  end
end
