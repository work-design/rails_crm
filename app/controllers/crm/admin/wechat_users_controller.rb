module Crm
  class Admin::WechatUsersController < Auth::Admin::WechatUsersController
    include Controller::Admin

    def index
      q_params = {}
      q_params.merge! appid: current_organ.wechat_apps.pluck(:appid) if defined?(current_organ) && current_organ
      q_params.merge! params.permit(:user_id, :uid, :appid, :name)

      @wechat_users = Wechat::WechatUser.includes(:user, :authorized_tokens).default_where(q_params).order(id: :desc).page(params[:page])

      @contacts = Contact.where(default_params)
    end

    

  end
end
