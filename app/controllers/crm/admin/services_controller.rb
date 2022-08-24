module Crm
  class Admin::ServicesController < Serve::ServicesController
    layout 'admin'
    before_action :set_maintain
    before_action :set_cart

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def set_cart
      @cart = @maintain.carts.find_or_create_by(good_type: 'Serve::Service', aim: 'use')
    end

    def _xprefixes
      super do |pres|
        if ['show'].include?(params[:action])
          pres + ['trade/my/wallet_templates', 'trade/my/base']
        else
          pres
        end
      end
    end

  end
end
