module Crm
  class Me::MaintainSourcesController < Me::BaseController
    before_action :set_sources, only: [:index]
    before_action :set_source, only: [:list, :source]

    def index
      q_params = {}
      q_params.merge! default_params

      @maintain_sources = MaintainSource.default_where(q_params)
    end

    def list
      @sources = @source.children
    end

    def source
      @primary_material = @source.materials.find(&->(i){ i.is_a?(PrimaryMaterial) })
      if current_corp_user
        @contact = current_corp_user.contacts.find_or_initialize_by(state: @source.name)
        @contact.save
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
