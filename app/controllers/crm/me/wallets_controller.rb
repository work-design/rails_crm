module Crm
  class Me::WalletsController < Crm::Admin::WalletsController

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end
