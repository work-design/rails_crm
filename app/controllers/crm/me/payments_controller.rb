module Crm
  class Me::PaymentsController < Admin::PaymentsController
    include Controller::Me

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end
