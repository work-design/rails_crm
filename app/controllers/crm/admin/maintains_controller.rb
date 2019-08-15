class Crm::Admin::MaintainsController < Crm::Admin::BaseController
  before_action :set_maintain, only: [
    :show, :courses, :edit, :update, :orders,
    :edit_order, :update_order,
    :edit_transfer, :update_transfer,
    :edit_assign, :update_assign,
    :detach, :assume, :destroy
  ]
  before_action :prepare_form, only: [:new, :create_detect, :edit]

  def index
    q_params = {}
    q_params.merge! member_params
    if params[:myself] && current_member
      q_params.merge! member_id: current_member.id
    end
    q_params.merge! search_params
    if (q_params.keys - [:member_id]).blank?
      q_params.merge! state: 'init'
    end
    
    @maintain_sources = MaintainSource.default_where(organ_ancestors_params)
    @maintain_tags = MaintainTag.default_where(organ_ancestors_params)
    @pipelines = Pipeline.default_where(organ_ancestors_params)
    @maintains = Maintain.default_where(q_params).includes(:tutelage, :maintain_source, :member, :maintain_logs).order(id: :desc).page(params[:page]).per(params[:per])
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
    @tutelar = Profile.default_where(q_params).find_by(identity: params[:identity])
    if @tutelar
      @tutelages = @tutelar.proteges
      
      respond_to do |format|
        format.js { render 'create_detect' }
        format.json { render 'create_detect' }
      end
    else
      @maintain = Maintain.new
      @maintain.member_id = current_member.id if current_member
      @maintain.tutelar = Profile.new(identity: params[:identity])
      @maintain.client = Profile.new
      @maintain.build_tutelage
      
      respond_to do |format|
        format.js { render 'new' }
        format.json {
          @tutelages = Tutelage.none
          render 'create_detect'
        }
      end
    end
  end

  def new
    @maintain = Maintain.new
    @maintain.member_id = current_member.id if current_member
    if params[:tutelar_id]
      @maintain.tutelar = Profile.find params[:tutelar_id]
    else
      @maintain.tutelar = Profile.new
    end
    if params[:tutelage_id]
      tutelage = Tutelage.find params[:tutelage_id]
      @maintain.tutelage = tutelage
      @maintain.client = tutelage.pupil
    else
      @maintain.client = Profile.new
    end
  end

  def create
    @maintain = Maintain.new(maintain_params)
    if client_params[:id]
      @maintain.client = Profile.find client_params[:id]
    else
      @maintain.client = Profile.new client_params
    end
    if tutelar_params[:id]
      @maintain.tutelar = Profile.find tutelar_params[:id]
    else
      @maintain.tutelar = Profile.new tutelar_params
    end
    if tutelage_params[:id]
      @maintain.tutelage = Tutelage.find tutelage_params[:id]
    else
      @maintain.tutelage = Tutelage.new tutelage_params
    end

    respond_to do |format|
      if @maintain.save
        format.html.phone { redirect_to admin_maintains_url }
        format.html { redirect_to admin_maintains_url }
        format.json { render 'show' }
        format.js { redirect_to admin_maintains_url }
      else
        logger.debug "#{@maintain.error_text}"
        format.html.phone { render 'new' }
        format.html { render 'new' }
        format.json { process_errors(@maintain) }
        format.js { redirect_to admin_maintains_url }
      end
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

  def show
  end

  def courses
    q_params = {}
    q_params.merge! course: default_params
    @course_crowds = CourseCrowd.default_where(q_params).page(params[:page])
  end

  def edit
  end

  def update
    @maintain.assign_attributes(update_params)

    respond_to do |format|
      if @maintain.save
        format.html { redirect_to admin_maintains_url }
        format.json { render 'show' }
        format.js { redirect_to admin_maintains_url }
      else
        format.html { render 'edit' }
        format.js
        format.json
      end
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
  
    order = advance.generate_order! buyer: @maintain.tutelar, maintain_id: @maintain.id
    flash[:notice] = "已下单，请等待财务核销, 订单号为：#{order.uuid}"
    redirect_to orders_admin_maintain_url(@maintain, order_id: order.id)
  end

  def destroy
    @maintain.destroy
    redirect_to admin_maintains_url
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
    @maintain_sources = MaintainSource.default_where(organ_ancestors_params)
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
    if p[:member_id].blank? && current_member
      p.merge! member_id: current_member.id
    end
    p
  end
  
  def update_params
    maintain_params.merge! params.fetch(:maintain, {}).permit(client_attributes: {}, tutelar_attributes: {}, tutelage_attributes: {})
  end
  
  def client_params
    p = params.fetch(:maintain, {}).fetch(:client_attributes, {}).permit!
    p.merge! default_form_params
  end
  
  def tutelar_params
    p = params.fetch(:maintain, {}).fetch(:tutelar_attributes, {}).permit!
    p.merge! default_form_params
  end
  
  def tutelage_params
    params.fetch(:maintain, {}).fetch(:tutelage_attributes, {}).permit!
  end
  
  def search_params
    params.permit(
      :state,
      :maintain_source_id,
      :pipeline_id,
      'client.real_name',
      'client.real_name-like',
      'client.birthday-gte',
      'client.birthday-lte',
      'tutelar.identity',
      'created_at-gte',
      'created_at-lte',
      'maintain_logs.maintain_tag_id'
    )
  end

end
