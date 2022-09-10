module Crm
  class Me::FacilitatesController < Admin::FacilitatesController
    include Controller::Me

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end
