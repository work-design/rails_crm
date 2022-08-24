module Crm
  class Admin::ServicesController < Serve::ServicesController
    before_action :set_maintain

    def index
      q_params = {}
      q_params.merge! params.permit(:tel)
    end

    private
    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client
    end

    def _xprefixes
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
