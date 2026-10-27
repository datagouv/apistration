class Admin::EditorTokens::Create < ApplicationOrganizer
  before do
    context.admin_activity_name = 'editor_token_created'
    context.admin_entity_key = :editor_token
    context.editor_token_creation_source = 'admin'
  end

  organize Admin::EditorTokens::CreateToken,
    Admin::EditorTokens::CaptureCreationAttributes,
    EditorToken::TrackCreation,
    Admin::TrackActivity
end
