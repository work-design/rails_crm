module Crm
  module Controller::Admin
    extend ActiveSupport::Concern
    include Controller::Application

    included do
      layout -> { turbo_frame_body? ? 'frame_body' : 'admin' }
    end

    private
    def set_common_maintain
      if params[:client_id]
        @client = Client.default_where(default_ancestors_params).find params[:client_id]
      elsif params[:contact_id]
        @client = Contact.default_where(default_ancestors_params).find params[:contact_id]
      elsif params[:client_member_id]
        @client = Org::Member.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_member_id]
      elsif params[:client_organ_id]
        @client = Org::Organ.where.associated(:client_maintains).where(client_maintains: { organ_id: current_organ.id }).find params[:client_organ_id]
      elsif params[:maintain_id]
        @client = Maintain.default_where(default_ancestors_params).find params[:maintain_id]
      else
      end
    end

  end
end
