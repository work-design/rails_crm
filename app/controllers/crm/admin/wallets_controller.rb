module Crm
  class Admin::WalletsController < Trade::Admin::WalletsController
    before_action :set_maintain
    before_action :set_wallet, only: [:show, :edit, :update, :destroy, :actions]

    def index
      q_params = {}

      @wallets = @maintain.wallets.default_where(q_params).order(id: :desc)
      @wallet_templates = Trade::WalletTemplate.default_where(default_params).where.not(id: @wallets.pluck(:wallet_template_id))
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_wallet
      @wallet = @wallet_template.wallets.find(params[:id])
    end

    def wallet_params
      params.fetch(:wallet, {}).permit(
        :account_bank,
        :account_name,
        :account_num
      )
    end

  end
end