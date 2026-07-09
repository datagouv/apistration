class Editor::TokensController < EditorController
  def index
    @editor_tokens = current_editor.tokens.order(created_at: :desc)
  end

  def create
    authorize EditorToken

    @editor_token = current_editor.tokens.create!(
      iat: Time.zone.now.to_i,
      exp: 18.months.from_now.to_i
    )

    render :created
  end
end
