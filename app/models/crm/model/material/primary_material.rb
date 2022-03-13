module Crm
  module Model::Material::PrimaryMaterial
    extend ActiveSupport::Concern

    included do

    end

    def qrcode
      tag.materials.find(&->(i){ i.is_a?(QrcodeMaterial) })
    end

    def text
      tag.materials.find(&->(i){ i.is_a?(TextMaterial) })
    end

    def url_with_watermark
      t = qrcode.watermark
      t += text.watermark if text

      [picture.url, t].join('!')
    end

  end
end
