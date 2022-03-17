module Crm
  class Source < ApplicationRecord
    include Model::Source
    include Trade::Model::Good

    def order_paid(trade_item)
      maintain_source = maintain_sources.find_or_initialize_by(organ_id: trade_item.member_organ_id)

      mc = material_contacts.build
      mc.trade_item = trade_item
      mc.maintain_source = maintain_source

      mc.save
    end
  end
end
