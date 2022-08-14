module Crm
  class MaintainImport
    extend RailsData::Import

    config do
      model Maintain
      column :amount, header: 'My name', field: -> {}
      column :email, header: 'Email', field: -> {}
    end
  end
end
