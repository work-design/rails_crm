module Crm
  module Ext::Account
    extend ActiveSupport::Concern

    included do
      has_many :contacts, class_name: 'Crm::Contact', primary_key: :identity, foreign_key: :identity
      #after_save_commit :sync_user_later, if: -> { saved_change_to_user_id? }
    end

    def sync_user_later
      AccountSyncUserJob.perform_later(self)
    end

    def sync_user
      contacts.each do |contact|
        contact.client_user_id ||= user_id
      end
    end

  end
end
