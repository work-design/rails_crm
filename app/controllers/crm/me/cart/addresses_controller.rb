module Crm::Me
  class Cart::AddressesController < AddressesController
    before_action :set_cart

    private
    def set_cart
      @cart = Trade::Cart.find params[:cart_id]
    end

    def _prefixes
      super do |pres|
        if ['index'].include?(params[:action])
          pres = ["ship/my/addresses/_#{params[:action]}", 'ship/my/addresses/_base', 'ship/my/addresses']
        else
          pres
        end
      end
    end

  end
end
