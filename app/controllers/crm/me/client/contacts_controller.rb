module Crm
  class Me::Client::ContactsController < Admin::Client::ContactsController
    include Controller::Me
  end
end
