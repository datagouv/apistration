class Admin::EditorContacts::Destroy < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_contact_removed'
    context.admin_entity_key = :editor
    context.association = :contacts
  end

  organize Admin::Editors::FindRecord,
    Admin::Editors::DestroyRecord,
    Admin::Editors::CaptureRecordAttributes,
    Admin::TrackActivity
end
