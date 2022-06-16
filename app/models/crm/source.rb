module Crm
  class Source < ApplicationRecord
    include Model::Source
    include Com::Ext::Taxon
    include Trade::Ext::Good

    def order_paid(trade_item)
      maintain_source = maintain_sources.find_or_initialize_by(organ_id: trade_item.member_organ_id)

      mc = source_contacts.build
      mc.trade_item = trade_item
      mc.maintain_source = maintain_source
      mc.contact_id = Hash(trade_item.extra).fetch('contact_id')

      mc.save
    end
  end
end
