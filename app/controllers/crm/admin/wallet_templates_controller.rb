module Crm
  class Admin::WalletTemplatesController < Trade::Admin::WalletTemplatesController
    include Controller::Admin
    before_action :set_common_maintain

  end
end
