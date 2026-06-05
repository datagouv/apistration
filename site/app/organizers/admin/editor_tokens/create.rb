class Admin::EditorTokens::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_token_created'
    context.admin_entity_key = :editor_token
  end

  organize Admin::EditorTokens::CreateToken,
    Admin::EditorTokens::CaptureCreationAttributes,
    Admin::TrackActivity
end
