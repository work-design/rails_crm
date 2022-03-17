module Crm
  module Model::MaterialContact
    extend ActiveSupport::Concern

    included do

      belongs_to :maintain_source
      belongs_to :material
      belongs_to :contact, class_name: 'Wechat::Contact'
      belongs_to :trade_item, class_name: 'Trade::TradeItem'
    end

    def url_with_watermark

    end

  end
end
