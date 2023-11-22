module Crm
  class Admin::ClientsController < Admin::BaseController
    before_action :set_client, only: [
      :show, :edit, :update, :destroy, :actions,
      :edit_assign, :update_assign
    ]
    before_action :set_new_client, only: [:new, :create]

    def index
      q_params = {}
      q_params.merge! default_params

      @clients = Client.includes(:client_maintains, :pending_members).default_where(q_params).order(id: :desc).page(params[:page])
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
    end

    def update_assign
      @maintain = @client.client_maintains.build(maintain_params)
      @maintain.save
    end

    private
    def set_new_client
      @client = Client.new(client_params)
    end

    def set_client
      @client = Client.default_where(default_params).find params[:id]
    end

    def client_params
      _p = params.fetch(:client, {}).permit(
        :name
      )
      _p.merge! default_form_params
    end

    def maintain_params
      params.fetch(:maintain, {}).permit(
        :member_id
      )
    end

  end
end
