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

  end
end
