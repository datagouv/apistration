class Editor::TokensController < EditorController
  def index
    @editor_tokens = current_editor.tokens.order(created_at: :desc)
  end
end
