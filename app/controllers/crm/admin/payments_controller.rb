module Crm
  class Admin::PaymentsController < Trade::Admin::PaymentsController
    before_action :set_maintain

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

  end
end
