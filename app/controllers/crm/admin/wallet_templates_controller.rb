module Crm
  class Admin::WalletTemplatesController < Trade::Admin::WalletTemplatesController
    before_action :set_maintain
    before_action :set_wallet_template, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_order, only: [:show]
    before_action :set_wallet_template_ids, only: [:index]

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)

      @wallet_templates = Trade::WalletTemplate.default_where(q_params).page(params[:page])
    end

    def show
      @wallet = @maintain.wallets.find_or_initialize_by(wallet_template_id: @wallet_template.id)
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_new_order
      @order = @maintain.orders.build
      @order.items.build
    end

    def set_wallet_template_ids
      @wallet_template_ids = @maintain.wallets.pluck(:wallet_template_id)
    end

    def _prefixes
      super do |pres|
        if ['show'].include?(params[:action])
          pres + ['trade/my/wallet_templates', 'trade/my/base']
        else
          pres
        end
      end
    end

  end
end
