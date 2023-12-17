module Crm
  class Contact < ApplicationRecord
    include Model::Contact
    include Ext::Agent
    include Wechat::Ext::Contact if defined? RailsWechat
  end
end
