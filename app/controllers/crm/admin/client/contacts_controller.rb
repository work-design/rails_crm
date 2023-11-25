module Crm
  class Admin::Client::ContactsController < Admin::ContactsController
    before_action :set_client
    before_action :set_contact, only: [
      :show, :edit, :update, :destroy, :actions,
      :edit_assign, :update_assign, :edit_member, :init_member
    ]
    before_action :set_new_contact, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @contacts = @client.contacts.includes(:client_maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def edit_member
      @members = @client.pending_members
    end

    def init_member
      @client.build_client_member(identity: @client.identity)
      @client.save
    end

    private
    def set_client
      @client = Client.find params[:client_id]
    end

    def set_new_contact
      @contact = @client.contacts.build(contact_params)
    end

    def set_contact
      @client = @client.contacts.default_where(default_params).find params[:id]
    end

    def maintain_params
      params.fetch(:maintain, {}).permit(
        :member_id
      )
    end

  end
end
