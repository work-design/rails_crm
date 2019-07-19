require 'active_support/configurable'

module RailsCrm #:nodoc:
  include ActiveSupport::Configurable

  configure do |config|
    config.app_controller = 'ApplicationController'
    config.my_controller = 'MyController'
    config.admin_controller = 'AdminController'
    config.member_controller = 'MemberController'
  end

end


