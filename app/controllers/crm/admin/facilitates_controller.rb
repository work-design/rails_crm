module Crm
  class Admin::FacilitatesController < defined?(RailsBench) ? Bench::FacilitatesController : Admin::BaseController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart

    private
    def set_cart
      @cart = @maintain.carts.find_or_create_by(good_type: 'Bench::Facilitate', aim: 'use')
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
