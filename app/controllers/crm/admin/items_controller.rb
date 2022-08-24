module Crm
  class Admin::ItemsController < Trade::Admin::ItemsController
    before_action :set_maintain

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def set_new_item
      options = {}
      options.merge! client_id: @maintain.client_id
      options.merge! params.permit(:good_type, :good_id, :aim, :number, :produce_on, :scene_id, :fetch_oneself, :current_cart_id)

      @item = Item.new(options)
    end

  end
end
