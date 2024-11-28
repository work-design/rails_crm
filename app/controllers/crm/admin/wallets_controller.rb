module Crm
  class Admin::WalletsController < Trade::Admin::CustomWalletsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_wallet, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_wallet, only: [:index, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @custom_wallets = @client.custom_wallets.default_where(q_params).order(wallet_template_id: :desc)
      @wallet_templates = Trade::WalletTemplate.default_where(default_params).order(id: :asc)
      if @custom_wallets.present?
        @wallet_templates = @wallet_templates.includes(logo_attachments: :blob).where.not(id: @custom_wallets.pluck(:wallet_template_id))
      end
    end

    private
    def set_wallet
      @wallet = @client.wallets.find(params[:id])
    end

    def set_new_wallet
      @wallet = @client.wallets.build(wallet_params)
    end

    def set_new_order
      @order = @client.orders.build
      @order.items.build
    end

    def wallet_params
      _p = params.fetch(:wallet, {}).permit(
        :account_bank,
        :account_name,
        :account_num,
        :wallet_template_id,
        :type
      )
      _p.merge! default_form_params
    end

  end
end
