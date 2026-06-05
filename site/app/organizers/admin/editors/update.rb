class Admin::Editors::Update < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_updated'
    context.admin_entity_key = :editor
    context.admin_before_attributes = context.editor.slice('name', 'form_uids', 'copy_token', 'delegations_enabled')
  end

  organize Admin::Editors::UpdateModel,
    Admin::TrackActivity
end
