module Crm
  class Admin::CartsController < Trade::Admin::CartsController
    before_action :set_maintain

    def show
      q_params = {}

      @items = @cart.items.includes(produce_plan: :scene).default_where(q_params).order(id: :asc).page(params[:page])
      @checked_ids = @cart.items.default_where(q_params).unscope(where: :status).status_checked.pluck(:id)
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end
