module Crm
  class Me::WalletPaymentsController < Crm::Admin::WalletPaymentsController

    private
    def set_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client
    end

  end
end