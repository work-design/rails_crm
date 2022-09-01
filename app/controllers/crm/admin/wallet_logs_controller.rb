module Crm
  class Admin::WalletLogsController < Trade::Admin::WalletLogsController
    before_action :set_maintain
    before_action :set_wallet
    before_action :set_wallet_log, only: [:show, :edit, :update, :destroy, :actions]

    def index
      @wallet_logs = @wallet.wallet_logs.order(id: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def set_wallet
      @wallet = @client.wallets.find params[:wallet_id]
    end

    def set_wallet_log
      @wallet_log = @wallet.wallet_logs.find params[:id]
    end

  end
end
