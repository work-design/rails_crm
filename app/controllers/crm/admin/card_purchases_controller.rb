module Crm
  class Admin::CardPurchasesController < Trade::Admin::CardPurchasesController
    include Controller::Admin
    before_action :set_common_maintain

    private
    def set_card
      @card = @client.cards.find params[:card_id]
    end

  end
end
