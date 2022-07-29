module Crm
  class Admin::WalletPaymentsController < Trade::Admin::WalletPaymentsController
    before_action :set_maintain
    before_action :set_wallet
    before_action :set_wallet_payment, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_wallet_payment, only: [:new, :create]

    def index
      q_params = {}

      @wallet_payments = @wallet.wallet_payments.default_where(q_params).page(params[:page])
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_wallet
      @wallet = @maintain.wallets.find params[:wallet_id]
    end

    def set_new_wallet_payment
      @wallet_payment = @wallet.wallet_payments.build(wallet_payment_params)
      @wallet_payment.notified_at ||= Time.current
    end

    def set_wallet_payment
      @wallet_payment = Trade::WalletPayment.find(params[:id])
    end

    def wallet_payment_params
      params.fetch(:wallet_payment, {}).permit(
        :total_amount,
        :notified_at,
        :comment
      )
    end

  end
end
