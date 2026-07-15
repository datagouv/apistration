module DatapassWebhook::V2
  class APIParticulierDemarcheNumerique < ApplicationOrganizer
    before do
      context.api = 'particulier'
      context.authorization_request_data ||= {}
      context.modalities = context.authorization_request_data['modalities'].presence || %w[params]
    end

    organize ::DatapassWebhook::AdaptV2ToV1,
      ::DatapassWebhook::FindOrCreateUser,
      ::DatapassWebhook::FindOrCreateAuthorizationRequest,
      ::DatapassWebhook::FindOrCreateOrganization,
      ::DatapassWebhook::CreateOrProlongToken,
      ::DatapassWebhook::CreateEditorDelegation,
      ::DatapassWebhook::ArchiveCurrentAuthorizationRequest,
      ::DatapassWebhook::RefuseCurrentAuthorizationRequest,
      ::DatapassWebhook::RevokeCurrentToken,
      ::DatapassWebhook::UpdateMailjetContacts
  end
end
