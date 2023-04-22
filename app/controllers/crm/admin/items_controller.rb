module Crm
  class Admin::ItemsController < Trade::Admin::ItemsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_new_item, only: [:create]

    private
    def set_new_item
      options = {}
      options.merge! common_maintain_params
      options.merge! params.permit(:good_type, :good_id, :aim, :number, :produce_on, :scene_id, :current_cart_id)

      @item = Trade::Item.new(options)
    end

  end
end
