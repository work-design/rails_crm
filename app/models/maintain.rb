class Maintain < ApplicationRecord
  include RailsCrm::Maintain
  include RailsEvent::Planned if defined? RailsEvent
end unless defined? Maintain
