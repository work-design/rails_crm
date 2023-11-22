module Crm
  class Client < ApplicationRecord
    include Model::Client
    include Inner::Client
  end
end
