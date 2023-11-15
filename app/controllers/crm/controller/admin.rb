module Crm
  module Controller::Admin
    extend ActiveSupport::Concern
    include Controller::Application

    included do
      layout 'admin'
    end

    private
    def set_common_maintain
      @maintain = Maintain.default_where(default_ancestors_params).find params[:maintain_id]
      set_client_user
    end

    class_methods do
      def local_prefixes
        [controller_path, 'crm/admin/base']
      end
    end

  end
end
