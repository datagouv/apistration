class EditorToken::Revoke < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.editor_token.revoked',
    target: :editor_token,
    computed_details: ->(context) { { editor_id: context.editor_token.editor_id } }

  organize EditorToken::RevokeModel,
    SecurityEvent::Track
end
