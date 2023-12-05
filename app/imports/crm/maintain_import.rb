module Crm
  class MaintainImport < ApplicationImport
    extend RailsData::Import

    config do
      model Contact
      column :name, header: 'My name', field: -> {}
      column :identity, header: 'Email', field: -> {}
    end
  end
end
