class Token::RevealEditorList < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.revealed',
    target: :token,
    computed_details: lambda { |context|
      { surface: 'editor_list', jtis: context.tokens.map(&:id), count: context.tokens.size, editor_id: context.editor.id }
    },
    only_if: ->(context) { context.editor.copy_token? && context.tokens.any? && !context.impersonating }

  organize SecurityEvent::Track
end
