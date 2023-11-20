module Crm
  module Controller::Application
    extend ActiveSupport::Concern

    def common_maintain_params
      {
        member_id: params[:client_member_id],
        member_organ_id: params[:client_organ_id],
        user_id: params[:client_user_id]
      }.compact_blank
    end

    def set_client_user
      if @maintain.client.user
        @client = @maintain.client.user
      else
        @client = @maintain.client
      end
    end

  end
end
