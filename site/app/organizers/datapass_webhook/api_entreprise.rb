module DatapassWebhook
  class APIEntreprise < ApplicationOrganizer
    before do
      context.api = 'entreprise'
    end

    organize ::DatapassWebhook::FindOrCreateUser,
      ::DatapassWebhook::FindOrCreateAuthorizationRequest,
      ::DatapassWebhook::FindOrCreateOrganization,
      ::DatapassWebhook::UpdateScopes,
      ::DatapassWebhook::CreateEditorDelegation,
      ::DatapassWebhook::ArchivePreviousAuthorizationRequest,
      ::DatapassWebhook::ArchiveCurrentAuthorizationRequest,
      ::DatapassWebhook::RevokeCurrentToken,
      ::DatapassWebhook::UpdateMailjetContacts,
      ::DatapassWebhook::ScheduleAuthorizationRequestEmails
  end
end
