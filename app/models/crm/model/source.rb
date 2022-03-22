module Crm
  module Model::Source
    extend ActiveSupport::Concern

    included do
      attribute :name, :string
      attribute :materialize, :boolean, default: false

      has_one :qrcode, dependent: :destroy
      has_many :texts, dependent: :destroy
      has_many :maintain_sources, dependent: :nullify
      has_many :source_contacts

      has_one_attached :picture
      has_one_attached :logo
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

    def url_with_watermark(replace = nil)
      t = "/fw/#{fw}"
      t += qrcode.watermark(replace) if qrcode
      texts.each do |text|
        t += text.watermark
      end

      [picture.url, t.presence].compact.join('!')
    end

  end
end
