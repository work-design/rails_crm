module Crm
  module Controller::Application
    extend ActiveSupport::Concern

    def common_maintain_params
      {
        contact_id: params[:contact_id],
        client_id: params[:client_id],
      }.compact_blank
    end

  end
end
