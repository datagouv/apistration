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
    computed_details: ->(context) { config_change(context) },
    only_if: ->(context) { changed_settings(context).any? }

  organize SecurityEvent::Track

  def self.changed_settings(context)
    context.editor.saved_changes.slice(*SETTINGS.keys).merge(form_uids_change(context)).transform_keys(SETTINGS)
  end

  def self.form_uids_change(context)
    before = context.form_uids_before
    after = context.editor.form_uids
    before.nil? || before == after ? {} : { 'form_uids' => [before, after] }
  end

  def self.config_change(context)
    changes = changed_settings(context)

    {
      changed_settings: changes.keys,
      before: changes.transform_values(&:first),
      after: changes.transform_values(&:last)
    }
  end
end
