module Crm
  class Admin::Client::ContactsController < Admin::ContactsController
    before_action :set_client
    before_action :set_contact, only: [
      :show, :edit, :update, :destroy, :actions,
      :edit_assign, :update_assign, :edit_member, :init_member, :update_default
    ]
    before_action :set_new_contact, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @contacts = @client.contacts.includes(:client_maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def edit_member
      @members = @contact.pending_members
    end

    def init_member
      @contact.build_client_member(identity: @contact.identity)
      @contact.save
    end

    def update_default
      @contact.assign_attributes contact_default_params
      @contact.save
    end

    private
    def set_client
      @client = Client.find params[:client_id]
    end

    def set_new_contact
      @contact = @client.contacts.build(contact_params)
    end

    def set_contact
      @contact = @client.contacts.default_where(default_params).find params[:id]
    end

    def contact_default_params
      params.fetch(:contact, {}).permit(
        :default
      )
    end

  end
end
