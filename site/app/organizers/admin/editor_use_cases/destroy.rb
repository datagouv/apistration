class Admin::EditorUseCases::Destroy < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_use_case_removed'
    context.admin_entity_key = :editor
    context.association = :use_cases
  end

  organize Admin::Editors::CaptureFormUids,
    Admin::Editors::FindRecord,
    Admin::Editors::DestroyRecord,
    Admin::Editors::CaptureRecordAttributes,
    Editor::TrackConfigChange,
    Admin::TrackActivity
end
