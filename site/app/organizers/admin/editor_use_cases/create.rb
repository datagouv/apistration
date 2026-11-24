class Admin::EditorUseCases::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_use_case_created'
    context.admin_entity_key = :editor
    context.association = :use_cases
  end

  organize Admin::Editors::CaptureFormUids,
    Admin::Editors::CreateRecord,
    Admin::Editors::CaptureRecordAttributes,
    Editor::TrackConfigChange,
    Admin::TrackActivity
end
