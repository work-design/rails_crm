module Crm
  class Admin::ScanPaymentsController < Trade::Admin::ScanPaymentsController
    include Controller::Admin
    before_action :set_common_maintain

  end
end
