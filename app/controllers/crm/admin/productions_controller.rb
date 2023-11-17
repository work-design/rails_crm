module Crm
  class Admin::ProductionsController < Factory::ProductionsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart

    private
    def set_cart
      options = { agent_id: current_member.id, client_id: @client.id }
      options.merge! default_params
      @cart = Trade::Cart.where(options).find_or_create_by(good_type: 'Factory::Production', aim: 'use')
      @cart.compute_amount! unless @cart.fresh
    end

    def _prefixes
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
