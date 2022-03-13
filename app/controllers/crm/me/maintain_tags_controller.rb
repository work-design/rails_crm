module Crm
  class Me::MaintainTagsController < Me::BaseController

    def index
      @tags = Tag.all
    end

  end
end
