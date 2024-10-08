module Crm
  module Model::Text
    extend ActiveSupport::Concern

    included do
      attribute :note, :string
      attribute :margin_x, :integer, default: 0
      attribute :margin_y, :integer, default: 0

      enum :font, {
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
      }, prefix: true, default: 'simsun'

      enum :align, {
        center: 'center',
        north: 'north',
        south: 'south',
        west: 'west',
        east: 'east',
        northwest: 'northwest',
        northeast: 'northeast',
        southwest: 'southwest',
        southeast: 'southeast'
      }, prefix: true, default: 'northwest'

      belongs_to :source
    end

    def watermark
      "/watermark/text/#{Base64.urlsafe_encode64(note)}/font/#{font}/align/#{align}/margin/#{margin_x}x#{margin_y}"
    end

  end
end
