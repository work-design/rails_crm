module Crm
  module Model::Material::QrcodeMaterial

    def watermark(blob = nil)
      blob ||= picture
      "/watermark/url/#{Base64.urlsafe_encode64('/' + [blob.service.try(:folder), blob.key].compact.join('/'))}/align/#{align}/margin/#{margin_x}x#{margin_y}"
    end

  end
end
