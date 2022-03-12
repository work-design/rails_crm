module Crm
  module Model::Material
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :extra, :json

      belongs_to :tag

      has_one_attached :picture
    end

  end
end
