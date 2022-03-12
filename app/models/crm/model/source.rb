module Crm
  module Model::Source
    extend ActiveSupport::Concern

    included do
      attribute :name, :string

      has_many :maintain_sources
    end

  end
end
