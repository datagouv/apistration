module DatapassWebhook::V2
  class APIParticulierDemarcheNumerique < ApplicationOrganizer
    before do
      context.api = 'particulier'
      context.authorization_request_data ||= {}
      context.modalities = context.authorization_request_data['modalities'].presence || %w[params]
      context.announce_created_token = true
    end

    organize ::DatapassWebhook::AdaptV2ToV1,
      ::DatapassWebhook::FindOrCreateUser,
      ::DatapassWebhook::FindOrCreateAuthorizationRequest,
      ::DatapassWebhook::FindOrCreateOrganization,
      ::DatapassWebhook::UpdateScopes,
      ::DatapassWebhook::CreateEditorDelegation,
      ::DatapassWebhook::CreateTokenOnValidation,
      ::DatapassWebhook::ArchiveCurrentAuthorizationRequest,
      ::DatapassWebhook::RevokeCurrentToken,
      ::DatapassWebhook::UpdateMailjetContacts
  end
end
