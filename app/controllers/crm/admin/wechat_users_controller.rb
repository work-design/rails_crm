module Crm
  class Admin::WechatUsersController < Crm::Admin::BaseController
    include Controller::Admin
    before_action :set_wechat_user, only: [:show, :edit, :contact]

    def index
      q_params = {}
      q_params.merge! appid: current_organ.apps.pluck(:appid)
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @wechat_users = Wechat::WechatUser.includes(:user, :app).default_where(q_params).order(id: :desc).page(params[:page])
      @contacts = Contact.where(default_params).where(unionid: @wechat_users.pluck(:unionid))
    end

    def online
      q_params = {}
      q_params.merge! appid: current_organ.apps.pluck(:appid)
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @wechat_users = Wechat::WechatUser.includes(:user, :app).where.not(online_at: nil).where(offline_at: nil).default_where(q_params).order(id: :desc).page(params[:page])
      @contacts = Contact.where(default_params).where(unionid: @wechat_users.pluck(:unionid))
    end

    def contact
      @contact = @wechat_user.contacts.build(organ_id: current_organ.id)
      @contact.name = @wechat_user.name
      @contact.save
    end

    private
    def set_wechat_user
      @wechat_user = Wechat::WechatUser.where(appid: current_organ.apps.pluck(:appid)).find params[:id]
    end

  end
end
