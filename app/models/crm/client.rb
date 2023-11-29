module Crm
  class Client < ApplicationRecord
    include Com::Ext::Taxon
    include Model::Client
  end
end
