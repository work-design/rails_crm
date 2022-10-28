module Crm
  class Admin::WalletsController < Trade::Admin::WalletsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_wallet, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_wallet, only: [:index, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @wallets = @client.wallets.default_where(q_params).order(wallet_template_id: :desc)
      @wallet_templates = Trade::WalletTemplate.default_where(default_params).where.not(id: @wallets.pluck(:wallet_template_id)).order(id: :asc)
    end

    def xx

    end

    private
    def set_wallet
      @wallet = @client.wallets.find(params[:id])
    end

    def set_new_wallet
      @wallet = @maintain.wallets.build(wallet_params)
    end

    def set_new_order
      @order = @maintain.orders.build
      @order.items.build
    end

    def wallet_params
      params.fetch(:wallet, {}).permit(
        :account_bank,
        :account_name,
        :account_num,
        :wallet_template_id
      )
    end

    def self.local_prefixes
      [controller_path, 'crm/admin/base']
    end

  end
end
