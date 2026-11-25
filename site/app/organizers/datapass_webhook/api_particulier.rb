module DatapassWebhook
  class APIParticulier < ApplicationOrganizer
    before do
      context.api = 'particulier'
      context.authorization_request_data ||= {}
      context.modalities = context.authorization_request_data['modalities'].presence || %w[params]
    end

    organize ::DatapassWebhook::FindOrCreateUser,
      ::DatapassWebhook::FindOrCreateAuthorizationRequest,
      ::DatapassWebhook::FindOrCreateOrganization,
      ::DatapassWebhook::UpdateScopes,
      ::DatapassWebhook::CreateEditorDelegation,
      ::DatapassWebhook::CreateTokenOnValidation,
      ::DatapassWebhook::ArchiveCurrentAuthorizationRequest,
      ::DatapassWebhook::RevokeCurrentToken,
      ::DatapassWebhook::UpdateMailjetContacts,
      ::DatapassWebhook::ScheduleCreateFormulaireQFResourcesJob,
      ::DatapassWebhook::ScheduleAuthorizationRequestEmails,
      ::DatapassWebhook::APIParticulier::NotifyReporters
  end
end
