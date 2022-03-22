module Crm
  module Model::Qrcode
    extend ActiveSupport::Concern

    included do
      attribute :extra, :json
      attribute :margin_x, :integer, default: 0
      attribute :margin_y, :integer, default: 0
      attribute :fw, :integer, default: 0

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
