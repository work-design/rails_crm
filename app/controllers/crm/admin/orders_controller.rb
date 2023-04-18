module Crm
  class Admin::OrdersController < Trade::Admin::OrdersController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_addresses, :set_new_order, only: [:new, :create]
    before_action :set_payment_strategies, only: [:new, :create, :edit, :update]
    before_action :set_order, only: [:show, :payment_types, :print_data, :package, :edit, :update, :destroy, :actions]
    before_action :set_new_order, only: [:new, :add, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @orders = @client.orders.default_where(q_params).includes(:payment_strategy).order(id: :desc).page(params[:page])
    end

    def new
      @order.items.build
    end

    def add
      @order.valid?
      @order.sum_amount
    end

    def create
      @order.compute_promote
      @order.valid?

      if params[:commit].present? && @order.save
        render 'create'
      else
        @order.items.build
        render 'new'
      end
    end

    private
    def set_new_order
      @order = @maintain.orders.build(order_params)
    end

    def set_order
      @order = @client.orders.find params[:id]
    end

    def set_addresses
      @addresses = @client.addresses.page(params[:page])
    end

    def set_payment_strategies
      @payment_strategies = Trade::PaymentStrategy.default_where(default_params)
    end

    def _prefixes
      super do |pres|
        if ['add'].include?(params[:action])
          pres + ['trade/my/orders/_add', 'trade/my/orders']
        elsif ['payment_types'].include?(params[:action])
          pres + ['trade/my/orders/_payment_types']
        elsif ['show'].include?(params[:action])
          pres + ['trade/my/orders/_show', 'trade/my/orders/_base']
        else
          pres
        end
      end
    end

  end
end
