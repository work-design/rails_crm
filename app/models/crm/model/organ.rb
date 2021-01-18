module Crm
  module Model::Organ
    extend ActiveSupport::Concern

    included do
      has_many :maintains, dependent: :nullify
      has_many :pupils, through: :maintains
    end

    def maintains_count
      maintains.select(:source_id).distinct.count
    end

  end
end
