class Admin::EditorUseCases::Update < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_use_case_updated'
    context.admin_entity_key = :editor
    context.association = :use_cases
  end

  organize Admin::Editors::CaptureFormUids,
    Admin::Editors::FindRecord,
    Admin::Editors::UpdateRecord,
    Admin::Editors::CaptureRecordAttributes,
    Editor::TrackConfigChange,
    Admin::TrackActivity
end
