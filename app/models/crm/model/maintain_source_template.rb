module Crm
  module Model::MaintainSourceTemplate
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      has_many :maintain_sources
    end

  end
end
