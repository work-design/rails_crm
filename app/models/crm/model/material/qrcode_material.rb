module Crm
  module Model::Material::QrcodeMaterial

    def watermark
      "/watermark/url/#{Base64.urlsafe_encode64('/meal_dev/' + picture.key)}/align/#{align}/margin/#{margin_x}x#{margin_y}"
    end

  end
end
