module Crm
  class Admin::ContactsController < Admin::BaseController
    before_action :set_contact, only: [
      :show, :edit, :update, :destroy, :actions,
      :edit_assign, :update_assign
    ]
    before_action :set_scene, only: [:show]
    before_action :set_new_contact, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! params.permit(:identity, 'name-like')

      @contacts = Contact.includes(:maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def maintain
      q_params = {}
      q_params.merge! default_params

      @contacts = Contact.includes(:maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def new_detect
    end

    def create_detect
      q_params = { identity: params[:identity] }
      q_params.merge! default_params
      @contacts = Contact.default_where(q_params)

      if @contacts.present?
        render 'create_detect'
      else
        @contact = Contact.new(identity: params[:identity])
        render 'new', locals: { model: @contact }
      end
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

    def set_scene
      app = current_organ.apps.official.take
      if app
        @scene = app.scenes.find_or_create_by(match_value: @client.bind_path)
      end
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
