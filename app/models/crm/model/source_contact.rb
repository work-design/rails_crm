module Crm
  module Model::SourceContact
    extend ActiveSupport::Concern

    included do
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :maintain_source
      belongs_to :source
      belongs_to :contact, class_name: 'Wechat::Contact'
      belongs_to :trade_item, class_name: 'Trade::TradeItem', optional: true
    end

    def url_with_watermark
      primary_material = source.materials.find(&->(i){ i.is_a?(PrimaryMaterial) })
      primary_material.url_with_watermark(contact.file)
    end

  end
end
