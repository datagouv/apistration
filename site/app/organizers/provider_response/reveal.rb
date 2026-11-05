class ProviderResponse::Reveal < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'admin.provider_response.revealed',
    target: :endpoint,
    actor: ADMIN_ACTOR,
    computed_details: lambda { |context|
      {
        endpoint_uid: context.endpoint&.uid,
        endpoint_path: context.endpoint_path,
        provider_uids: context.endpoint&.provider_uids,
        provider_status: context.provider_response[:status]
      }
    },
    only_if: ->(context) { context.provider_response.present? }

  organize ProviderResponse::FindEndpoint,
    SecurityEvent::Track
end
