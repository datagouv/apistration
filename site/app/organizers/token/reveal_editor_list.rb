class Token::RevealEditorList < ApplicationOrganizer
  include SecurityEvent::Tracking

  tracks_security_event 'token.api_token.revealed',
    target: :token,
    computed_details: lambda { |context|
      revealed = context.authorization_requests.select(&:token)
      {
        surface: 'editor_list',
        jtis: revealed.map { |authorization_request| authorization_request.token.id },
        datapass_ids: revealed.map(&:external_id),
        count: revealed.size,
        editor_id: context.editor.id
      }
    },
    only_if: ->(context) { context.editor.copy_token? && context.authorization_requests.any?(&:token) && !context.impersonating }

  organize SecurityEvent::Track
end
