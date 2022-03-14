module Crm
  module Model::Material::TextMaterial

    def watermark
      "/watermark/text/#{Base64.urlsafe_encode64(note)}/font/#{font}/align/#{align}/margin/#{margin_x}x#{margin_y}"
    end

  end
end
