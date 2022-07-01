module Crm
  class Admin::OrdersController < Trade::Admin::OrdersController
    before_action :set_maintain
    before_action :set_addresses, :set_new_order, only: [:new, :create]
    before_action :set_payment_strategies, only: [:new, :create, :edit, :update]

    def index
      @orders = @maintain.orders.order(id: :desc).page(params[:page])
    end

    def new
      @order.trade_items.build
    end

    def edit
      @card_templates = Trade::CardTemplate.default_where(default_params)
    end

    def update
      q_params = default_params
      q_params.merge! params.permit(:advance_id)
      advance = Trade::Advance.find(q_params['advance_id'])

      order = advance.generate_order! buyer: @maintain.agent, maintain_id: @maintain.id
      flash[:notice] = "已下单，请等待财务核销, 订单号为：#{order.uuid}"
      redirect_to orders_admin_maintain_url(@maintain, order_id: order.id)
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_new_order
      @order = @maintain.orders.build(order_params)
    end

    def set_addresses
      @addresses = @maintain.addresses.page(params[:page])
    end

    def set_payment_strategies
      @payment_strategies = Trade::PaymentStrategy.default_where(default_params)
    end

  end
end
