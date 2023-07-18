module Crm
  module Model::SourceContact
    extend ActiveSupport::Concern

    included do
      belongs_to :organ, class_name: 'Org::Organ', optional: true

      belongs_to :maintain_source
      belongs_to :source
      belongs_to :contact, class_name: 'Wechat::Contact'
      belongs_to :trade_item, class_name: 'Trade::TradeItem', optional: true

      has_one :qy_media, class_name: 'Wechat::QyMedia', as: :medium
    end

    def url_with_watermark
      source.url_with_watermark(contact.file)
    end

    def to_qy_media
      r = nil
      Tempfile.open do |file|
        file.binmode
        res = HTTPX.get url_with_watermark
        res.body.each do |fragment|
          file.write fragment
        end if res.error.nil?

        file.rewind
        qy_media || build_qy_media(corpid: contact.corpid, suite_id: contact.suite_id)
        r = qy_media.corp.api.uploadimg(file)
        qy_media.url = r['url']
        qy_media.save
        logger.debug "#{r}"
      end
      r
    end

  end
end
