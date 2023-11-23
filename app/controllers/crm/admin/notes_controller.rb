module Crm
  class Admin::NotesController < Admin::BaseController
    before_action :set_maintain
    before_action :set_note, only: [:show, :edit, :update, :destroy, :actions]
    before_action :set_new_note, only: [:new, :create]
    before_action :set_maintain_tags, only: [:new, :edit]

    def index
      @notes = @maintain.notes.order(id: :desc).page(params[:page]).per(params[:per])
    end

    private
    def set_maintain_tags
      @maintain_tags = MaintainTag.default_where(default_params)
    end

    def set_maintain
      @maintain = Maintain.find params[:maintain_id]
    end

    def set_note
      @note = @maintain.notes.find(params[:id])
    end

    def set_new_note
      @note = @maintain.notes.build(note_params)
      @note.member = current_member
    end

    def note_params
      params.fetch(:note, {}).permit(
        :maintain_tag_id,
        :note,
        :file,
        :logged_type,
        :logged_id
      )
    end

  end
end
