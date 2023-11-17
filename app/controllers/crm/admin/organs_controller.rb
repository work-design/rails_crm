module Crm
  class Admin::OrgansController < Admin::BaseController

    def index
      @organs = Maintain.includes(:client_organ).page(params[:page])
    end

    private
    def modal_name
      'organ'
    end

  end
end
