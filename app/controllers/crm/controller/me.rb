module Crm
  module Controller::Me
    extend ActiveSupport::Concern
    include Controller::Application

    included do
      layout 'me'
    end

    def set_common_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      set_client_user
    end

  end
end
