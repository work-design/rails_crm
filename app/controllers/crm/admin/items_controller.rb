module Crm
  class Admin::ItemsController < Trade::Admin::ItemsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart, only: [:create, :update, :destroy]
    before_action :set_cart_item, only: [:update, :destroy]
    before_action :set_new_item, only: [:create]

    private
    def set_cart
      if current_cart
        @cart = current_cart
      else
        options = { agent_id: current_member.id }
        options.merge! default_form_params
        options.merge! common_maintain_params
        @cart = Trade::Cart.where(options).find_or_create_by(good_type: params[:good_type], aim: params[:aim].presence || 'use')
      end
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
