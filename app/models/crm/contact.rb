module Crm
  class Contact < ApplicationRecord
    include Model::Contact
    include Ext::Agent
    include Wechat::Ext::Contact if defined? RailsWechat
    if defined? RailsAudit
      include Auditor::Ext::Discard
      include Auditor::Ext::Audited
    end
  end
end
