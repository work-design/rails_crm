module Crm
  class Contact < ApplicationRecord
    include Model::Profile
    include Inner::Client
    include Ext::Agent
    include Wechat::Ext::Profile if defined? RailsWechat
  end
end
