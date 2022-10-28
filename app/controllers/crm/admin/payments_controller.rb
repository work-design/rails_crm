module Crm
  class Admin::PaymentsController < Trade::Admin::PaymentsController
    include Controller::Admin
    before_action :set_common_maintain

  end
end
