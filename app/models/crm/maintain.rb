module Crm
  class Maintain < ApplicationRecord
    include Model::Maintain
    include Eventual::Ext::Planned if defined? RailsEvent
  end
end
