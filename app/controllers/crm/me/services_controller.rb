module Crm
  class Me::ServicesController < Admin::ServicesController

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end
