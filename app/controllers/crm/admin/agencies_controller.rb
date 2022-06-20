module Crm
  class Admin::AgenciesController < Admin::BaseController
    before_action :set_agency, only: [
      :show, :edit, :update,
      :edit_crowd, :update_crowd, :destroy_crowd, :destroy_card,
      :destroy
    ]

    def index
      q_params = {}
      #q_params.merge! default_params
      #q_params.merge! member_id: current_member.id if current_member
      q_params.merge! params.permit('client.real_name')

      @agencies = Agency.distinct.joins(:cards).where.not(cards: { id: nil }).default_where(q_params).order(id: :desc).page(params[:page])
    end

    def edit_crowd
      q_params = {
        'id-not': @agency.crowd_ids
      }
      q_params.merge! default_params
      @crowds = Crowd.default_where(q_params)
    end

    def update_crowd
      if @agency.join_crowd params[:crowd_id]
        render 'update'
      else
        render :edit_crowd, locals: { model: @agency }, status: :unprocessable_entity
      end
    end

    def destroy_crowd
      cs = @agency.crowd_members.find_by(crowd_id: params[:crowd_id])
      if cs&.destroy
        render 'update'
      end
    end

    def destroy_card
      card = @agency.cards.find(params[:card_id])
      card.agency = nil
      card.client = nil

      if card.save
        render 'update'
      end
    end

    private
    def set_agency
      @agency = Agency.find(params[:id])
    end

    def agency_params
      params.fetch(:agency, {}).permit(
        :real_name,
        :gender,
        :note
      )
    end

  end
end
