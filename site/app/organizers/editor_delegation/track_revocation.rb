class EditorDelegation::TrackRevocation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'delegation.editor.revoked',
    target: :delegation,
    computed_details: lambda { |context|
      {
        source: context.delegation_revocation_source,
        editor_id: context.delegation.editor_id,
        datapass_id: context.delegation.authorization_request.external_id
      }
    }

  organize SecurityEvent::Track
end
