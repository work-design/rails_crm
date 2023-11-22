module Crm
  class Contact < ApplicationRecord
    include Model::Contact
    include Ext::Agent
    include Wechat::Ext::Profile if defined? RailsWechat
  end
end
