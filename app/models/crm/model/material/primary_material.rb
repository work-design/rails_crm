module Crm
  module Model::Material::PrimaryMaterial
    extend ActiveSupport::Concern

    included do

    end

    def qrcode
      source.materials.find(&->(i){ i.is_a?(QrcodeMaterial) })
    end

    def text
      source.materials.find(&->(i){ i.is_a?(TextMaterial) })
    end

    def url_with_watermark(replace = nil)
      t = ''
      t += qrcode.watermark(replace) if qrcode
      t += text.watermark if text

      [picture.url, t.presence].compact.join('!')
    end

  end
end
