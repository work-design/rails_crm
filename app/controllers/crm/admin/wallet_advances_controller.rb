module Crm
  class Admin::WalletAdvancesController < Trade::Admin::WalletAdvancesController
    before_action :set_maintain
    before_action :set_wallet
    before_action :set_wallet_advance, only: [:show, :edit, :update, :actions]
    before_action :set_new_wallet_advance, only: [:new, :create]

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def set_wallet
      @wallet = @client.wallets.find params[:wallet_id]
    end

  end
end
