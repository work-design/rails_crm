module Crm
  class MaintainImport < ApplicationImport
    extend RailsData::Import

    config do
      model Contact
      column :name, header: 'My name', field: ->(i) { i}
      column :identity, header: 'Email', field: ->(i) { i }
    end
  end
end
