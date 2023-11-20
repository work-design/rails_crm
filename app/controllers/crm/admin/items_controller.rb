module Crm
  class Admin::ItemsController < Trade::Admin::ItemsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart, only: [:create]
    before_action :set_new_item, only: [:create]

    private
    def set_cart
      if params[:current_cart_id].present?
        @cart = Trade::Cart.find params[:current_cart_id]
      elsif item_params[:current_cart_id].present?
        @cart = Trade::Cart.find item_params[:current_cart_id]
      else
        options = { agent_id: current_member.id }
        options.merge! default_form_params
        options.merge! common_maintain_params
        @cart = Trade::Cart.where(options).find_or_create_by(good_type: params[:good_type], aim: params[:aim].presence || 'use')
      end
    end

    def set_new_item
      options = {}
      options.merge! params.permit(:good_id, :produce_on, :scene_id)

      @item = @cart.find_item(**options) || @cart.items.build(options)
      @item.status = 'checked'
      @item.assign_attributes params.permit(['station_id', 'desk_id', 'current_cart_id'] & Trade::Item.column_names)
      @item.number = @item.number.to_i + (params[:number].presence || 1).to_i if @item.persisted?
    end

  end
end
