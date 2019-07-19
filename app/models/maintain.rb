class Maintain < ApplicationRecord
  include RailsCrm::Maintain
  include RailsBooking::Booker
  include RailsBooking::Plan
end unless defined? Maintain
