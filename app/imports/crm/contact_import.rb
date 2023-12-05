module Crm
  class ContactImport < ApplicationImport
    extend RailsData::Import

    config do
      model Contact
      column :name, header: 'My name', field: ->(i) { i.to_s }
      column :identity, header: 'Email', field: ->(i) { i }
    end
  end
end
