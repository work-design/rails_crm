module Crm
  class Admin::WalletLogsController < Trade::Admin::WalletLogsController
    before_action :set_maintain
    before_action :set_wallet

    def index
      @wallet_logs = @wallet.wallet_logs.order(id: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_wallet
      @wallet = @maintain.wallets.find params[:wallet_id]
    end

  end
end
