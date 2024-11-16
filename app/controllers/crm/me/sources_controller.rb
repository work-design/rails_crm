module Crm
  class Me::SourcesController < Me::BaseController
    before_action :set_sources, only: [:index]
    before_action :set_source, only: [:list, :source]

    def index
      q_params = {}
      q_params.merge! default_params

      @sources = Source.default_where(q_params).roots
    end

    def list
      @sources = @source.children
    end

    def source
      if current_corp_user
        @contact = current_corp_user.contacts.find_or_initialize_by(state: @source.name)
        @contact.save
        logger.debug "\e[35m  Contact ID: #{@contact.id}  \e[0m"
      else
        @scene = current_member.invite_contact!(@source.name)
        @requests = @scene.requests.includes(:wechat_user).order(id: :desc).page(params[:page])
        render 'invite_qrcode'
      end
    end

    def share

    end

    private
    def set_sources
      @sources = Source.roots
    end

    def set_source
      @source = Source.find params[:source_id]
    end

  end
end
