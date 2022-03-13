module Crm
  module Model::Material
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :note, :string
      attribute :extra, :json
      attribute :left_x, :integer, default: 0
      attribute :top_y, :integer, default: 0

      enum font: {
        simsun: 'simsun',
        simhei: 'simhei',
        simkai: 'simkai',
        simli: 'simli',
        simyou: 'simyou',
        simfang: 'simfang',
        sc: 'sc',
        tc: 'tc',
        arial: 'arial',
        georgia: 'georgia',
        helvetica: 'helvetica',
        roman: 'roman'
      }, _prefix: true, _default: 'simsun'

      belongs_to :tag

      has_one_attached :picture
    end

  end
end
