module Crm
  class My::ContactsController < My::BaseController
    before_action :set_contact, only: [:show, :edit, :update, :destroy, :actions, :edit_bind, :update_bind]

    def edit_bind
    end

    def update_bind
      @contact.client_user = current_user
      @contact.save
    end

    private
    def set_contact
      @contact = Contact.find params[:id]
    end

  end
end
