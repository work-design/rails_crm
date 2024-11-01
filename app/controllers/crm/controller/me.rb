module Crm
  module Controller::Me
    extend ActiveSupport::Concern
    include Controller::Application

    def set_common_maintain
      if params[:client_id]
        @client = current_member.agent_clients.find params[:client_id]
      elsif params[:contact_id]
        @client = current_member.agent_contacts.find params[:contact_id]
      elsif params[:maintain_id]
        @client = current_member.maintains.find params[:maintain_id]
      end
    end

  end
end
