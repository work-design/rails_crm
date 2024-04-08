module Crm
  class Admin::OrdersController < Trade::Admin::OrdersController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_addresses, :set_new_order, only: [:new, :create]
    before_action :set_payment_strategies, only: [:new, :new_simple, :create, :edit, :update]
    before_action :set_order, only: [:show, :payment_types, :print_data, :package, :edit, :update, :destroy, :actions, :micro]
    before_action :set_new_order, only: [:new, :new_simple, :add, :create]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:payment_status, :state)

      @orders = @client.orders.default_where(q_params).includes(:payment_strategy).order(id: :desc).page(params[:page])
    end

    def add
      @order.valid?
    end

    def payment_types
      if @order.items.map(&:good_type).exclude?('Trade::Advance') && @order.can_pay?
        @order.wallets.where(wallet_template_id: @order.wallet_codes).each do |wallet|
          @order.payments.build(type: 'Trade::WalletPayment', wallet_id: wallet.id)
        end
      end
    end

    private
    def set_new_order
      @order = @client.orders.build(order_params)
    end

    def set_order
      set_common_maintain
      @order = @client.orders.find params[:id]
    end

    def set_addresses
      @addresses = @client.addresses.page(params[:page])
    end

    def set_payment_strategies
      @payment_strategies = Trade::PaymentStrategy.default_where(default_params)
    end

  end
end
