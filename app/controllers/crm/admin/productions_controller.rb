module Crm
  class Admin::ProductionsController < Factory::ProductionsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart

    private
    def set_cart
      @cart = @maintain.carts.find_or_create_by(good_type: 'Factory::Production', aim: 'use', organ_id: current_organ.id)
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
