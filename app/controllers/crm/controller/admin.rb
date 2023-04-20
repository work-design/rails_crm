module Crm
  module Controller::Admin
    extend ActiveSupport::Concern

    private
    def set_common_maintain
      @maintain = Maintain.find params[:maintain_id]
      @client = @maintain.client.account&.user || @maintain.client.users[0] || @maintain.client
    end

  end
end
