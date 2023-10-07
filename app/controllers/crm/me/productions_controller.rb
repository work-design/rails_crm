module Crm
  class Me::ProductionsController < Admin::ProductionsController
    include Controller::Me
    layout 'agent'

  end
end
