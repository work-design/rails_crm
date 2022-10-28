module Crm
  class Admin::WalletAdvancesController < Trade::Admin::WalletAdvancesController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_wallet
    before_action :set_wallet_advance, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_wallet_advance, only: [:new, :create]

    private
    def set_wallet
      @wallet = @client.wallets.find params[:wallet_id]
    end

  end
end
