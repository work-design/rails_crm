module Crm
  class Admin::ContactsController < Admin::BaseController
    before_action :set_contact, only: [
      :show, :edit, :update, :destroy, :actions,
      :edit_assign, :update_assign
    ]
    before_action :set_new_contact, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @contacts = Contact.includes(:client_maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def edit_assign
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params

      @members = Org::Member.default_where(default_params)
      @client.client_maintains.build
    end

    def update_assign
      @client.assign_attributes(contact_params)
      @client.save
    end

    private
    def set_new_contact
      @contact = Contact.new(contact_params)
    end

    def set_contact
      @client = Contact.default_where(default_params).find params[:id]
    end

    def contact_params
      _p = params.fetch(:contact, {}).permit(
        :identity,
        :name,
        :client_member_id,
        client_maintains_attributes: [:id, :member_id]
      )
      _p.merge! default_form_params
    end

  end
end
