class Admin::Editors::Update < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_updated'
    context.admin_entity_key = :editor
    context.admin_before_attributes = context.editor.slice(
      'name', 'siret', 'role', 'contact_email', 'contact_phone',
      'deployment_type', 'setup_instructions', 'domain', 'languages',
      'description', 'form_uids', 'allowed_ips', 'copy_token', 'editor_tokens_enabled'
    )
  end

  organize Admin::Editors::UpdateModel,
    Admin::TrackActivity
end
