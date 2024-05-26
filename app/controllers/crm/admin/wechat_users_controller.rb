module Crm
  class Admin::WechatUsersController < Crm::Admin::BaseController
    include Controller::Admin
    before_action :set_wechat_user, only: [:show, :edit, :contact]

    def index
      q_params = {}
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @wechat_users = Wechat::WechatUser.includes(:user).joins(:app).where(app: { organ_id: current_organ.id }).default_where(q_params).order(id: :desc).page(params[:page])
      @contacts = Contact.where(default_params).where(unionid: @wechat_users.pluck(:unionid))
    end

    def set_contact
      @contact = @wechat_user.contacts.build(organ_id: current_organ.id)
      @contact.name = @wechat_user.name
      @contact.save
    end

    private
    def set_wechat_user
      @wechat_user = Wechat::WechatUser.joins(:app).where(app: { organ_id: current_organ.id }).find params[:id]
    end

  end
end
