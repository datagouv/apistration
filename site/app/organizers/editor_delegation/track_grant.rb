class EditorDelegation::TrackGrant < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'delegation.editor.granted',
    target: :delegation,
    computed_details: lambda { |context|
      {
        source: context.delegation_source,
        editor_id: context.delegation.editor_id,
        datapass_id: context.delegation.authorization_request.external_id
      }
    },
    only_if: ->(context) { context.delegation&.previously_new_record? }

  organize SecurityEvent::Track
end
