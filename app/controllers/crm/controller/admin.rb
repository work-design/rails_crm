module Crm
  module Controller::Admin
    extend ActiveSupport::Concern
    include Controller::Application

    private
    def set_common_maintain
      @maintain = Maintain.default_where(default_ancestors_params).find params[:maintain_id]
      set_client_user
    end

  end
end
