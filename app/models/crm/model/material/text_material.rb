module Crm
  module Model::Material::TextMaterial

    def watermark
      "/watermark/text/#{Base64.urlsafe_encode64(note)}/font/#{font}/margin/#{left_x}x#{top_y}"
    end

  end
end
