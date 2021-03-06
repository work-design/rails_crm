module Crm
  class Admin::MaintainsController < Admin::BaseController
    before_action :set_maintain, only: [
      :show, :edit, :update, :orders,
      :edit_order, :update_order,
      :edit_transfer, :update_transfer,
      :edit_assign, :update_assign,
      :detach, :assume, :destroy
    ]
    before_action :prepare_form, only: [:new, :create_detect, :edit]

    def index
      q_params = {}
      q_params.merge! member_params
      q_params.merge! search_params
      if (q_params.keys - [:member_id]).blank?
        q_params.merge! state: 'init'
      end

      @maintain_sources = MaintainSource.default_where(default_params)
      @maintain_tags = MaintainTag.default_where(default_params)
      @pipelines = Bench::TaskTemplate.default_where(default_params.merge(tasking_type: 'Crm::Maintain'))
      @maintains = Maintain.default_where(q_params).includes(:agency, :maintain_source, :member, :maintain_logs).order(id: :desc).page(params[:page]).per(params[:per])
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
      q_params = {}
      q_params.merge! default_params
      @agent = Profile.default_where(q_params).find_by(identity: params[:identity])
      if @agent
        @agencies = @agent.proteges
          render 'create_detect'
      else
        @maintain = Maintain.new
        @maintain.member_id = current_member.id if current_member
        @maintain.agent = Profile.new(identity: params[:identity])
        @maintain.client = Profile.new
        @maintain.build_agency
        @agencies = Agency.none
        render 'new'
      end
    end

    def new
      @maintain = Maintain.new
      @maintain.member_id = current_member.id if current_member
      if params[:agent_id]
        @maintain.agent = Profile.find params[:agent_id]
      else
        @maintain.agent = Profile.new
      end
      if params[:agency_id]
        agency = Agency.find params[:agency_id]
        @maintain.agency = agency
        @maintain.client = agency.client
      else
        @maintain.client = Profile.new
      end
    end

    def create
      @maintain = Maintain.new(maintain_params)
      @maintain.member_id ||= current_member.id

      if client_params[:id]
        @maintain.client = Profile.find client_params[:id]
      else
        @maintain.client = Profile.new client_params
      end
      if agent_params[:id]
        @maintain.agent = Profile.find agent_params[:id]
      else
        @maintain.agent = Profile.new agent_params
      end
      if agency_params[:id]
        @maintain.agency = Agency.find agency_params[:id]
      else
        @maintain.agency = Agency.new agency_params
      end

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

      head :ok
    end

    def new_batch_assign
      pipeline_params = {
        'pipeline.piping_type': 'Maintain',
        'pipeline.piping_id': nil,
        position: 1
      }
      pipeline_params.merge! job_title_id: current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params
      job_title_ids = PipelineMember.default_where(pipeline_params).pluck(:job_title_id)

      @members = Member.default_where('member_departments.job_title_id': job_title_ids)
    end

    def create_batch_assign
      add_ids = params[:add_ids].to_s.split(',')
      @maintains = Maintain.where(id: add_ids)
      @maintains.update_all member_id: params[:member_id]

      redirect_back fallback_location: admin_maintains_url, notice: '移交成功'
    end

    def show
    end

    def edit
    end

    def update
      @maintain.assign_attributes(update_params)

      unless @maintain.save
        render :edit, locals: { model: @maintain }, status: :unprocessable_entity
      end
    end

    def edit_transfer
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.job_title_ids if current_member
      pipeline_params.merge! default_params
      @pipelines = Pipeline.default_where(pipeline_params)
      if @maintain.pipeline_member
        @members = Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
      else
        @members = Member.none
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
      @pipelines = Pipeline.default_where(pipeline_params)
      if @maintain.pipeline_member
        @members = Member.default_where('member_departments.job_title_id': @maintain.pipeline_member.job_title_id)
      else
        @members = Member.none
      end
    end

    def update_assign
      @maintain.assign_attributes maintain_params.slice(:pipeline_id, :member_id)
      @maintain.save

      redirect_back fallback_location: admin_maintains_url(id: params[:id]), notice: '移交成功'
    end

    def detach
      @maintain.update member_id: nil
      redirect_to admin_maintains_url
    end

    def assume
      @maintain.update member_id: current_member.id
      redirect_to admin_maintains_url
    end

    def orders
      @orders = @maintain.orders.order(id: :desc).page(params[:page])
    end

    def edit_order
      @card_templates = CardTemplate.default_where(default_params)
    end

    def update_order
      q_params = default_params
      q_params.merge! params.permit(:advance_id)
      advance = Advance.find(q_params['advance_id'])

      order = advance.generate_order! buyer: @maintain.agent, maintain_id: @maintain.id
      flash[:notice] = "已下单，请等待财务核销, 订单号为：#{order.uuid}"
      redirect_to orders_admin_maintain_url(@maintain, order_id: order.id)
    end

    def destroy
      @maintain.destroy
    end

    private
    def set_maintain
      @maintain = Maintain.find(params[:id])
    end

    def prepare_form
      pipeline_params = {
        piping_type: 'Maintain',
        piping_id: nil,
        'pipeline_members.position': 1
      }
      pipeline_params.merge! 'pipeline_members.job_title_id': current_member.lower_job_title_ids if current_member
      pipeline_params.merge! default_params
      @pipelines = Pipeline.default_where(pipeline_params)
      @maintain_sources = MaintainSource.default_where(default_params)
    end

    def maintain_params
      p = params.fetch(:maintain, {}).permit(
        :note,
        :pipeline_id,
        :pipeline_member_id,
        :member_id,
        :maintain_source_id
      )
      p.merge! default_form_params
      p
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
        :pipeline_id,
        :member_id,
        'client.real_name',
        'client.real_name-like',
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
