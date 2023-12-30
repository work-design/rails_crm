module Crm
  class Admin::ProductionsController < Factory::Agent::ProductionsController
    include Controller::Admin
    before_action :set_common_maintain
    before_action :set_cart

    def index
      q_params = {}
      q_params.merge! default_params
      q_params.merge! production_plans: { produce_on: params[:produce_on], scene_id: params[:scene_id] } if params[:produce_on] && params[:scene_id]
      q_params.merge! params.permit(:organ_id, :factory_taxon_id, 'name-like')

      @productions = Factory::Production.includes(:product, :production_plans).default_where(q_params).default.order(id: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_cart
      options = { agent_id: current_member.id }
      options.merge! default_params
      if params[:client_member_id]
        options.merge! member_id: @client.id
      elsif params[:client_id]
        options.merge! client_id: @client.id, contact_id: nil
      elsif params[:contact_id]
        options.merge! client_id: @client.client_id, contact_id: @client.id
      elsif params[:maintain_id]
        options.merge! client_id: @client.client_id, contact_id: @client.contact_id, agent_id: @client.member_id
      end
      @cart = Trade::Cart.where(options).find_or_create_by(good_type: 'Factory::Production', aim: 'use')
      @cart.compute_amount! unless @cart.fresh
    end

    def _prefixes
      super do |pres|
        if ['show'].include?(params[:action])
          pres + ['trade/my/wallet_templates', 'trade/my/base']
        else
          pres
        end
      end
    end

  end
end
