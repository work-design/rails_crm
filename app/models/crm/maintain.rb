module Crm
  class Maintain < ApplicationRecord
    include Model::Maintain
    include Eventual::Model::Planned if defined? RailsEvent
  end
end
