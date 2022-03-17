module Crm
  module Model::SourceContact
    extend ActiveSupport::Concern

    included do
      belongs_to :maintain_source
      belongs_to :source
      belongs_to :contact, class_name: 'Wechat::Contact', optional: true
      belongs_to :trade_item, class_name: 'Trade::TradeItem', optional: true
    end

    def url_with_watermark

    end

  end
end
