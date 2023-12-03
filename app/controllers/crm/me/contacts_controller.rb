module Crm
  class Me::ContactsController < Admin::ContactsController
    include Controller::Me

    def index
      @contacts = current_member.agent_contacts.page(params[:page])
    end

    private
    def set_new_contact
      @contact = current_member.agent_contacts.build(contact_params)
    end

  end
end
