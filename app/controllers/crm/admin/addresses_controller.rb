module Crm
  class Admin::AddressesController < Profiled::Admin::AddressesController
    before_action :set_maintain
    before_action :set_address, only: [:show, :edit, :update, :destroy]
    before_action :set_new_address, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)

      @addresses = @maintain.addresses.includes(:area).default_where(q_params).page(params[:page])
    end

    def new
      @address.area ||= Profiled::Area.new
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_address
      @address = @maintain.addresses.find(params[:id])
    end

    def set_new_address
      @address = @maintain.addresses.build(address_params)
    end

  end
end