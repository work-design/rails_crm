module Crm
  class Admin::ItemsController < Trade::Admin::ItemsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart, only: [:create, :update, :destroy]
    before_action :set_cart_item, only: [:update, :destroy]
    before_action :set_new_item, only: [:create]

    private
    def set_cart
      options = { agent_id: current_member.id }
      options.merge! common_maintain_params
      @cart = Trade::Cart.get_cart(params, **default_params, **options)
    end

    def set_cart_item
      @item = @cart.items.load.find params[:id]
      @item.current_cart = @cart
    end

    def set_new_item
      @item = @cart.init_cart_item(params)
    end

  end
end
