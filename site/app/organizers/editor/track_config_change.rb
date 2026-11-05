class Editor::TrackConfigChange < ApplicationOrganizer
  include SecurityEvent::Tracking

  SETTINGS = {
    'form_uids' => 'form_uids',
    'allowed_ips' => 'allowed_ips',
    'copy_token' => 'copy_jwt',
    'editor_tokens_enabled' => 'editor_jwt_enabled'
  }.freeze

  tracks_security_event 'access.editor_config.changed',
    target: :editor,
    actor: ADMIN_ACTOR,
    computed_details: ->(context) { config_change(context.editor) },
    only_if: ->(context) { changed_settings(context.editor).any? }

  organize SecurityEvent::Track

  def self.changed_settings(editor)
    editor.saved_changes.slice(*SETTINGS.keys).transform_keys(SETTINGS)
  end

  def self.config_change(editor)
    changes = changed_settings(editor)

    {
      changed_settings: changes.keys,
      before: changes.transform_values(&:first),
      after: changes.transform_values(&:last)
    }
  end
end
