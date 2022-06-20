module Crm
  module Model::Agency
    extend ActiveSupport::Concern

    included do
      attribute :relation, :string, default: 'unknown'
      attribute :commission_ratio, :decimal, precision: 4, scale: 2, comment: '交易时抽成比例'
      attribute :note, :string, comment: '备注'

      belongs_to :agent, class_name: 'Auth::User'
      belongs_to :client, class_name: 'Profiled::Profile'

      accepts_nested_attributes_for :client, reject_if: :all_blank

      enum relation: options_i18n(:relation).values.map { |i| [i.to_sym, i.to_s] }.to_h
    end

    def name
      "#{relation_i18n} #{client.name}"
    end

  end
end
