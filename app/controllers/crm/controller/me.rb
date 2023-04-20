module Crm
  module Controller::Me
    extend ActiveSupport::Concern

    included do
      layout 'me'
    end

    def set_common_maintain
      @maintain = current_member.maintains.find params[:maintain_id]
      @client = @maintain.client.account&.user || @maintain.client.user[0] || @maintain.client
    end

    class_methods do
      def local_prefixes
        [controller_path, 'crm/me/base', 'me']
      end
    end

  end
end
