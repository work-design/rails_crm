module Crm
  class Admin::AddressesController < Profiled::My::AddressesController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_address, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_address, only: [:new, :create, :order_new, :order_create, :from_new, :from_create]
    before_action :set_addresses, only: [:order, :order_from, :order_create, :from_create]

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)

      @addresses = @client.addresses.includes(:area, :station).default_where(q_params).page(params[:page])
    end

    def order_from
      @addresses = @client.addresses.includes(:area, :station).order(id: :desc).page(params[:page])
    end

    def order
      @addresses = @client.addresses.includes(:area, :station).order(id: :desc).page(params[:page])
    end

    def from_create
      @address.save
    end

    private
    def set_address
      @address = @client.addresses.find(params[:id])
    end

    def set_addresses
      @addresses = @client.addresses.includes(:area).order(id: :desc).page(params[:page])
    end

    def set_new_address
      @address = @client.addresses.build(address_params)
      @address.area ||= Profiled::Area.new
    end

  end
end
