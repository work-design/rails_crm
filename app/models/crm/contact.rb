module Crm
  class Contact < ApplicationRecord
    include Model::Contact
    include Inner::Client
    include Ext::Agent
    include Wechat::Ext::Profile if defined? RailsWechat
  end
end
