class EditorToken::Rotate < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.editor_token.rotated',
    target: :editor_token,
    computed_details: ->(context) { { editor_id: context.editor_token.editor_id, replacement_id: context.replacement.id } }

  organize EditorToken::RotateModel,
    SecurityEvent::Track
end
