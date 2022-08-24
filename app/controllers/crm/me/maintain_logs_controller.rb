module Crm
  class Me::MaintainLogsController < Crm::Admin::MaintainLogsController
    include Controller::Me

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
    end

  end
end
