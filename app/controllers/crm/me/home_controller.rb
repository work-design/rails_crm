module Crm
  class Me::HomeController < Me::BaseController

    def index
      @wechat_user = current_user.oauth_users.find_by(appid: current_wechat_app&.appid)
      unless @wechat_user
        @url = current_wechat_app.oauth2_url(state: current_account.identity, action: 'bind')
      end
    end

  end
end
