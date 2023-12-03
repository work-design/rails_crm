module Crm
  class Me::Client::OrdersController < Admin::Client::OrdersController
    include Controller::Me
  end
end
