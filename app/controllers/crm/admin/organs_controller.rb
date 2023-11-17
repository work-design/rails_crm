module Crm
  class Admin::OrgansController < Admin::BaseController

    def index
      @maintains = Maintain.includes(:client_organ).where.not(client_organ_id: nil).page(params[:page])
    end

    private
    def modal_name
      'organ'
    end

  end
end
