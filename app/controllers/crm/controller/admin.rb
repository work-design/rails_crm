module Crm
  module Controller::Admin
    extend ActiveSupport::Concern
    include Controller::Application

    included do
      layout 'admin'
    end

    private
    def set_common_maintain
      if params[:client_id]
        @client = Profiled::Profile.default_where(default_ancestors_params).find params[:client_id]
      elsif params[:client_member_id]
        @client = Org::Member.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_member_id]
      elsif params[:maintain_id]
        @maintain = Maintain.default_where(default_ancestors_params).find params[:maintain_id]
        if @maintain.client.user
          @client = @maintain.client.user
        else
          @client = @maintain.client
        end
      else
      end
    end

    class_methods do
      def local_prefixes
        [controller_path, 'crm/admin/base']
      end
    end

  end
end
