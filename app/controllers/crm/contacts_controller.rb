module Crm
  class ContactsController < BaseController
    before_action :require_user, only: [:qrcode]
    before_action :set_contact, only: [:qrcode]

    def index
      @boxes = @box_host.boxes.page(params[:page])
    end

    def qrcode

    end

    private
    def set_contact
      @contact = Contact.find_by id: params[:id]
    end

  end
end
