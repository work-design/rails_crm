module Crm
  class Admin::OrdersController < Admin::BaseController

    def index
      @orders = @maintain.orders.order(id: :desc).page(params[:page])
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


  end
end
