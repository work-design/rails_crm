module Crm
  class My::ContactsController < My::BaseController
    before_action :set_contact, only: [:show, :edit, :update, :destroy, :actions, :bind]

    def edit_bind
    end

    def update_bind
    end

    private
    def set_contact
      @contact = Contact.find params[:id]
    end

  end
end
