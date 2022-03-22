module Crm
  module Model::Qrcode
    extend ActiveSupport::Concern

    included do
      attribute :margin_x, :integer, default: 0
      attribute :margin_y, :integer, default: 0
      attribute :fixed_width, :integer, default: 0

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

    def watermark(blob = nil)
      blob ||= picture
      "/watermark/url/#{Base64.urlsafe_encode64('/' + [blob.service.try(:folder), blob.key].compact.join('/'))}/align/#{align}/margin/#{margin_x}x#{margin_y}/percent/#{percent}"
    end

    def percent
      min = [source.width, source.height].min
      source.fw / min
    end

  end
end
