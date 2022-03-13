module Crm
  class Me::MaintainTagsController < Me::BaseController
    before_action :set_tags, only: [:index]

    def index
      q_params = {}
      q_params.merge! default_params

      @maintain_tags = MaintainTag.default_where(q_params)
    end

    def tag
      @tag = Tag.find params[:tag_id]
      @contact = current_corp_user.contacts.build(state: @tag.name)
    end

    private
    def set_tags
      @tags = Tag.all
    end

  end
end
