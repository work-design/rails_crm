module Crm
  class Me::ContactsController < Admin::ContactsController
    include Controller::Me

    def index
      q_params = {}
      q_params.merge! default_params

      @contacts = current_member.agent_contacts.default_where(q_params).order(id: :desc).page(params[:page])
    end

    private
    def set_new_contact
      @contact = current_member.agent_contacts.build(contact_params)
    end

  end
end
