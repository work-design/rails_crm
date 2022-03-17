module Crm
  module Model::Source
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :materialize, :boolean, default: false

      has_many :maintain_sources, dependent: :nullify
      has_many :materials
      has_many :source_contacts

      has_one_attached :logo
    end

  end
end
