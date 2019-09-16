class Maintain < ApplicationRecord
  include RailsCrm::Maintain
  include RailsEvent::Planned
end unless defined? Maintain
