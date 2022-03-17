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
      @primary_material = @tag.materials.find(&->(i){ i.is_a?(PrimaryMaterial) })
      if current_corp_user
        @contact = current_corp_user.contacts.find_or_initialize_by(state: @tag.name)
        @contact.save
      end
    end

    private
    def set_tags
      @tags = Tag.all
    end

  end
end
