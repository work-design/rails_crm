module Crm
  module Model::Material
    extend ActiveSupport::Concern

    included do
      attribute :type, :string
      attribute :note, :string
      attribute :extra, :json
      attribute :margin_x, :integer, default: 0
      attribute :margin_y, :integer, default: 0
      attribute :percent, :integer, default: 0
      attribute :fw, :integer, default: 0

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

      enum align: {
        center: 'center',
        north: 'north',
        south: 'south',
        west: 'west',
        east: 'east',
        northwest: 'northwest',
        northeast: 'northeast',
        southwest: 'southwest',
        southeast: 'southeast'
      }, _prefix: true, _default: 'northwest'

      belongs_to :source

      has_one_attached :picture
    end

    def width
      if picture.attached?
        picture.blob.metadata.fetch('width', 0)
      else
        0
      end
    end

    def height
      if picture.attached?
        picture.blob.metadata.fetch('height', 0)
      else
        0
      end
    end

    def h_by_w
      Rational(height, width)
    end

    def fh
      (fw * h_by_w).to_i
    end

  end
end
