module Crm
  class Admin::CardsController < Trade::Admin::CardsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_card, :set_card_template, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_card_template_ids, only: [:index]
    before_action :set_card_templates
    before_action :set_new_order, only: [:show]
    before_action :set_new_card, only: [:create]

    def index
      q_params = {}
      q_params.merge! default_ancestors_params
      q_params.merge! params.permit(:tel)

      @cards = @client.cards.includes(:card_template).default_where(q_params).order(card_template_id: :desc)
      @card_templates = Trade::CardTemplate.default_where(default_ancestors_params).where.not(id: @cards.pluck(:card_template_id)).order(id: :asc)
    end

    private
    def set_card_templates
      @card_templates = Trade::CardTemplate.default_where(default_params)
    end

    def set_new_order
      @order = @maintain.orders.build
      @order.items.build
    end

    def set_card
      @card = @client.cards.find params[:id]
    end

    def set_new_card
      @card = @maintain.cards.build(card_params)
    end

    def set_card_template_ids
      @card_template_ids = @client.cards.pluck(:card_template_id)
    end

    def set_card_template
      @card_template = @card.card_template
    end

    def card_params
      params.fetch(:card, {}).permit(
        :card_template_id
      )
    end

    def _prefixes
      super do |pres|
        if ['show'].include?(params[:action])
          pres + ['trade/my/card_templates/_show', 'trade/my/card_templates', 'trade/my/base']
        else
          pres
        end
      end
    end

  end
end
