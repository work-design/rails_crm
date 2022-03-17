module Crm
  module Model::Material::QrcodeMaterial

    def watermark
      "/watermark/url/#{Base64.urlsafe_encode64('/' + [picture.service.try(:folder), picture.key].compact.join('/'))}/align/#{align}/margin/#{margin_x}x#{margin_y}"
    end

  end
end
