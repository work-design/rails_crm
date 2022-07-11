module Crm
  class Admin::WalletTemplatesController < Trade::Admin::WalletTemplatesController
    before_action :set_maintain
    before_action :set_wallet_template, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_address, only: [:new, :create, :order_new, :order_create, :from_new, :from_create]
    before_action :set_addresses, only: [:order, :order_from, :order_create, :from_create]

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)

      @wallet_templates = Trade::WalletTemplate.default_where(q_params)
    end

    def show
      @wallet = @maintain.wallets.find_or_initialize_by(wallet_template_id: @wallet_template.id)
    end

    def order_from
    end

    def from_create
      @address.save
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_address
      @address = @maintain.addresses.find(params[:id])
    end

    def set_addresses
      @addresses = @maintain.addresses.includes(:area).order(id: :desc).page(params[:page])
    end

    def set_new_address
      @address = @maintain.addresses.build(address_params)
      @address.area ||= Profiled::Area.new
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
