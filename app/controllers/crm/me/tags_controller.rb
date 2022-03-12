module Crm
  class Me::TagsController < Me::BaseController

    def index
      @tags = Tag.all
    end

  end
end
