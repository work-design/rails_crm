module Crm
  class Admin::CardTemplatesController < Trade::Admin::CardTemplatesController
    before_action :set_maintain
    before_action :set_wallet_template, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_address, only: [:new, :create, :order_new, :order_create, :from_new, :from_create]
    before_action :set_addresses, only: [:order, :order_from, :order_create, :from_create]

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)

      @card_templates = Trade::CardTemplate.default_where(default_params)
    end

    def xx
      q_params = default_params
      q_params.merge! params.permit(:advance_id)
      advance = Trade::Advance.find(q_params['advance_id'])

      order = advance.generate_order! buyer: @maintain.agent, maintain_id: @maintain.id
      flash[:notice] = "已下单，请等待财务核销, 订单号为：#{order.uuid}"
      redirect_to orders_admin_maintain_url(@maintain, order_id: order.id)
    end

    def show
      @wallet = @maintain.wallets.find_or_initialize_by(wallet_template_id: @wallet_template.id)
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def _prefixes
      super do |pres|
        if ['show'].include?(params[:action])
          pres + ['trade/my/card_templates', 'trade/my/base']
        else
          pres
        end
      end
    end

  end
end
