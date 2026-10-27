class Admin::Editors::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_created'
    context.admin_entity_key = :editor
  end

  organize Admin::Editors::CreateModel,
    Admin::Editors::CaptureCreationAttributes,
    Admin::TrackActivity
end
