module Crm
  class Admin::MaintainsController < Admin::BaseController
    before_action :set_maintain, only: [
      :show, :edit, :update, :destroy, :actions, :orders,
      :edit_order, :update_order,
      :edit_transfer, :update_transfer,
      :edit_assign, :update_assign,
      :edit_member, :init_member,
      :detach, :assume
    ]
    before_action :set_new_maintain, only: [:new, :create, :create_detect]
    before_action :set_task_templates, only: [:new, :create_detect, :edit, :update, :edit_assign, :edit_transfer] if defined? RailsBench
    before_action :set_maintain_sources, only: [:index, :public, :create_detect, :new, :create, :edit, :update]
    before_action :set_maintain_tags, only: [:index, :public]
    before_action :set_members, only: [:edit_assign, :edit_transfer]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! search_params
      if (q_params.keys - [:member_id]).blank?
        q_params.merge! state: 'init'
      end

      @maintains = Maintain.default_where(q_params).includes(:client, :agency, :maintain_source, :member, :notes).order(id: :desc).page(params[:page]).per(params[:per])
    end

    def public
      q_params = {}
      q_params.merge! search_params
      q_params.merge! 'pipeline_member.job_title_id': current_member.lower_job_title_ids + [nil] if current_member
      q_params.merge! default_params
      @maintains = Maintain.where(member_id: nil).default_where(q_params).page(params[:page])
    end

    def new
      if params[:agent_id]
        @maintain.agent = Contact.find params[:agent_id]
      end
      if params[:agency_id]
        agency = Agency.find params[:agency_id]
        @maintain.agency = agency
        @maintain.client = agency.client
      end
    end

    def create_batch
      maintains_params = params.fetch(:maintains, {})
      maintains_params.each do |maintain_params|
        p = maintain_params.permit!
        p.merge! default_form_params
        maintain = Maintain.new
        maintain.build_client(p)
        maintain.save
      end
    end

    def new_batch_assign
      pipeline_params = {
        'pipeline.piping_type': 'Maintain',
        'pipeline.piping_id': nil,
        position: 1
      }
      pipeline_params.merge! job_title_id: current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params
      #job_title_ids = PipelineMember.default_where(pipeline_params).pluck(:job_title_id)

      @members = Org::Member.default_where('member_departments.job_title_id': job_title_ids)
    end

    def create_batch_assign
      add_ids = params[:add_ids].to_s.split(',')
      @maintains = Maintain.where(id: add_ids)
      @maintains.update_all member_id: params[:member_id]

      redirect_back fallback_location: admin_maintains_url, notice: '移交成功'
    end

    def edit_transfer
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.job_title_ids if current_member
      pipeline_params.merge! default_params

      #@members = Org::Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
    end

    def update_transfer
      @maintain.assign_attributes maintain_params
      @maintain.transfer!
    end

    def edit_assign
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params

      #@members = Org::Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
    end

    def update_assign
      @maintain.assign_attributes maintain_params
      @maintain.save
    end

    def detach
      @maintain.update member_id: nil
    end

    def assume
      @maintain.update member_id: current_member.id
    end

    private
    def set_maintain
      @maintain = Maintain.find(params[:id])
    end

    def set_new_maintain
      @maintain = Maintain.new(maintain_params)
    end

    def set_pipelines
      @pipelines = Bench::TaskTemplate.default_where(default_params.merge(tasking_type: 'Crm::Maintain'))
    end

    def set_members
      @members = Org::Member.default_where(default_params)
    end

    def set_task_templates
      pipeline_params = {
        tasking_type: 'Crm::Maintain',
        tasking_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params
      @task_templates = Bench::TaskTemplate.default_where(pipeline_params)
    end

    def set_maintain_sources
      @maintain_sources = MaintainSource.default_where(default_params)
    end

    def set_maintain_tags
      @maintain_tags = MaintainTag.default_where(default_params)
    end

    def maintain_params
      _p = params.fetch(:maintain, {}).permit(
        :note,
        :remark,
        :pipeline_member_id,
        :maintain_source_id,
        :agent_type,
        :member_id,
        :pipeline_id,
        :client_id,
        :client_member_id,
        :vendor,
        client_attributes: {},
        agent_attributes: {},
        agency_attributes: {}
      )
      _p.merge! default_form_params
      _p[:client_attributes].merge! default_form_params if _p[:client_attributes].present?
      _p[:agency_attributes].merge! default_form_params if _p[:agency_attributes].present?
      _p
    end

    def search_params
      params.permit(
        :state,
        :member_id,
        :maintain_source_id,
        'client.nick_name-like',
        'client.real_name-like',
        'client.identity',
        'client.birthday-gte',
        'client.birthday-lte',
        'agent.identity',
        'created_at-gte',
        'created_at-lte',
        'maintain_logs.maintain_tag_id'
      )
    end

  end
end
