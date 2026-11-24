class Admin::EditorContacts::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_contact_added'
    context.admin_entity_key = :editor
    context.association = :contacts
  end

  organize Admin::Editors::CreateRecord,
    Admin::Editors::CaptureRecordAttributes,
    Admin::TrackActivity
end
