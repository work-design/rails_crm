module Crm
  class Admin::OrderPaymentsController < Trade::Admin::OrderPaymentsController
    include Controller::Admin
    before_action :set_common_maintain

  end
end
