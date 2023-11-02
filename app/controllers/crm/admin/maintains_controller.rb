module Crm
  class Admin::MaintainsController < Admin::BaseController
    before_action :set_maintain, only: [
      :show, :edit, :update, :orders,
      :edit_order, :update_order,
      :edit_transfer, :update_transfer,
      :edit_assign, :update_assign,
      :detach, :assume, :destroy
    ]
    before_action :set_task_templates, only: [:new, :create_detect, :edit, :update] if defined? RailsBench
    before_action :set_payment_strategies, only: [:new, :create_detect, :edit, :update] if defined? RailsTrade
    before_action :set_maintain_sources, only: [:index, :public, :create_detect, :new, :create, :edit, :update]
    before_action :set_maintain_tags, only: [:index, :public]

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! search_params
      if (q_params.keys - [:member_id]).blank?
        q_params.merge! state: 'init'
      end

      @maintains = Maintain.default_where(q_params).includes(:client, :agency, :maintain_source, :member, :maintain_logs).order(id: :desc).page(params[:page]).per(params[:per])
    end

    def public
      q_params = {
        member_id: nil,
        allow: { member_id: nil }
      }
      q_params.merge! search_params
      q_params.merge! 'pipeline_member.job_title_id': current_member.lower_job_title_ids + [nil] if current_member
      q_params.merge! default_params
      @maintains = Maintain.default_where(q_params).page(params[:page])
    end

    def new_detect
    end

    def create_detect
      q_params = { identity: params[:identity] }
      q_params.merge! default_params
      @profiles = Profiled::Profile.default_where(q_params)

      if @profiles.present?
        render 'create_detect'
      else
        @maintain = current_member.maintains.build
        @maintain.profile_agent = Profiled::Profile.new(identity: params[:identity])
        @maintain.client = Profiled::Profile.new(identity: params[:identity])
        @maintain.build_agency
        render 'new', locals: { model: @maintain }
      end
    end

    def new
      @maintain = current_member.maintains.build

      if params[:agent_id]
        @maintain.agent = Profiled::Profile.find params[:agent_id]
      else
        @maintain.agent = Profiled::Profile.new
      end
      if params[:agency_id]
        agency = Agency.find params[:agency_id]
        @maintain.agency = agency
        @maintain.client = agency.client
      else
        @maintain.client = Profiled::Profile.new
      end
    end

    def create
      @maintain = Maintain.new(maintain_params)
      @maintain.member_id ||= current_member.id
      @maintain.client.organ = @maintain.organ

      unless @maintain.save
        render :new, locals: { model: @maintain }, status: :unprocessable_entity
      end
    end

    def batch
      maintains_params = params.fetch(:maintains, {})
      maintains_params.each do |maintain_params|
        p = maintain_params.permit!
        p.merge! default_form_params
        @maintain = Maintain.create(p)
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
      @pipelines = Bench::TaskTemplate.default_where(pipeline_params)
      if @maintain.pipeline_member
        @members = Org::Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
      else
        @members = Org::Member.none
      end
    end

    def update_transfer
      @maintain.assign_attributes maintain_params.slice(:pipeline_id)
      @maintain.transfer!

      redirect_back fallback_location: admin_maintains_url, notice: '移交成功'
    end

    def edit_assign
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params
      @pipelines = Bench::TaskTemplate.default_where(pipeline_params)
      if @maintain.pipeline_member
        @members = Org::Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
      else
        @members = Org::Member.none
      end
    end

    def update_assign
      @maintain.assign_attributes maintain_params.slice(:pipeline_id, :member_id)
      @maintain.save

      redirect_back fallback_location: admin_maintains_url(id: params[:id]), notice: '移交成功'
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

    def set_pipelines
      @pipelines = Bench::TaskTemplate.default_where(default_params.merge(tasking_type: 'Crm::Maintain'))
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

    def set_payment_strategies
      @payment_strategies = Trade::PaymentStrategy.default_where(default_params)
    end

    def set_maintain_sources
      @maintain_sources = MaintainSource.default_where(default_params)
    end

    def set_maintain_tags
      @maintain_tags = MaintainTag.default_where(default_params)
    end

    def maintain_params
      p = params.fetch(:maintain, {}).permit(
        :note,
        :remark,
        :pipeline_member_id,
        :maintain_source_id,
        :agent_type,
        client_attributes: {},
        agent_attributes: {},
        agency_attributes: {}
      )
      p.merge! default_form_params
    end

    def update_params
      maintain_params.merge! params.fetch(:maintain, {}).permit(client_attributes: {}, agent_attributes: {}, agency_attributes: {})
    end

    def client_params
      p = params.fetch(:maintain, {}).fetch(:client_attributes, {}).permit!
      p.merge! default_form_params
    end

    def agent_params
      p = params.fetch(:maintain, {}).fetch(:agent_attributes, {}).permit!
      p.merge! default_form_params
    end

    def agency_params
      params.fetch(:maintain, {}).fetch(:agency_attributes, {}).permit!
    end

    def search_params
      params.permit(
        :state,
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
