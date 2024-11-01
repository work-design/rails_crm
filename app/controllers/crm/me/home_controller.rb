module Crm
  class Me::HomeController < Admin::HomeController

    def index
      if defined? current_wechat_app
        #@wechat_user = current_member.oauth_users.find_by(appid: current_wechat_app&.appid)
        unless @wechat_user
          #@url = current_wechat_app.oauth2_url(state: current_account.identity, action: 'bind')
        end
      end
    end

  end
end
