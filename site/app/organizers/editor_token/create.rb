class EditorToken::Create < ApplicationOrganizer
  before do
    context.editor_token_creation_source = 'editor'
  end

  organize EditorToken::CreateModel,
    EditorToken::TrackCreation
end
