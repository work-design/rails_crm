module Crm::Me
  class Cart::AddressesController < AddressesController

    private
    def set_cart
      @cart = Trade::Cart.find params[:cart_id]
    end

  end
end
