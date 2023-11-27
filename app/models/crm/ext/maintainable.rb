module Crm
  module Ext::Maintainable
    extend ActiveSupport::Concern

    included do
      #belongs_to :maintain, class_name: 'Crm::Maintain', counter_cache: true, optional: true
      belongs_to :client, class_name: 'Crm::Client', optional: true
      belongs_to :contact, class_name: 'Crm::Contact', optional: true
      belongs_to :agent, class_name: 'Org::Member', optional: true
      accepts_nested_attributes_for :client

      #before_save :sync_from_maintain, if: -> { client_id.present? && maintain_id_changed? }
      before_validation :sync_from_contact, if: -> { (changes.keys & ['contact_id']).present? }
      before_validation :sync_from_client, if: -> { (changes.keys & ['client_id']).present? }

      #after_create :change_maintain_state, if: -> { maintain_id.present? && saved_change_to_maintain_id? }
    end

    def sync_from_maintain
      return unless maintain
      self.user_id = client.user_id
      #self.member_id = client.client_member_id
    end

    def sync_from_contact
      return unless contact
      self.client_id = contact.client_id
      self.user_id = contact.client_user_id
      self.member_id = contact.client_member_id
    end

    def sync_from_client
      return unless client
      self.member_organ_id = client.client_organ_id
    end

    def change_maintain_state
      return unless maintain
      maintain.update state: 'ordered'
    end

  end
end
