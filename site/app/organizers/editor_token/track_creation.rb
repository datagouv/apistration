class EditorToken::TrackCreation < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.editor_token.created',
    target: :editor_token,
    actor: ADMIN_ACTOR,
    computed_details: lambda { |context|
      { source: context.editor_token_creation_source, editor_id: context.editor_token.editor_id }
    }

  organize SecurityEvent::Track
end
