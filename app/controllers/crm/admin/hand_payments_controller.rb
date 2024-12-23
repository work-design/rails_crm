module Crm
  class Admin::HandPaymentsController < Trade::Admin::HandPaymentsController
    include Controller::Admin
    before_action :set_common_maintain

  end
end
