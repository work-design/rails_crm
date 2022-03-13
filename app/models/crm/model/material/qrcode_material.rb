module Crm
  module Model::Material::QrcodeMaterial

    def watermark
      "/watermark/url/#{Base64.urlsafe_encode64('/meal_dev/' + picture.key)}/margin/#{left_x}x#{top_y}"
    end

  end
end
