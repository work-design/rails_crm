module Crm
  class Admin::CartsController < Trade::My::CartsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart, only: [:show, :edit, :update]
    before_action :set_purchase, only: [:show]

    def index
      @carts = @maintain.carts.page(params[:page])
    end

    def show
      q_params = {}

      @items = @cart.items.includes(produce_plan: :scene).default_where(q_params).order(id: :asc).page(params[:page])
      @checked_ids = @cart.items.default_where(q_params).unscope(where: :status).status_checked.pluck(:id)
    end

    private
    def set_cart
      @cart = @maintain.carts.find params[:id]
    end

  end
end
