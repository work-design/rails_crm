module Crm
  class My::ContactsController < My::BaseController
    before_action :set_contact, only: [:show, :edit, :update, :destroy, :actions, :bind, :destroy_bind]

    def bind
      @contact.client_user = current_user
      @contact.save
    end

    def destroy_bind
      @contact.client_user = nil
      @contact.save
    end

    private
    def set_contact
      @contact = Contact.find params[:id]
    end

  end
end
