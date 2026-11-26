class Admin::EditorContacts::Update < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_contact_updated'
    context.admin_entity_key = :editor
    context.association = :contacts
  end

  organize Admin::Editors::FindRecord,
    Admin::Editors::UpdateRecord,
    Admin::Editors::CaptureRecordAttributes,
    Admin::TrackActivity
end
