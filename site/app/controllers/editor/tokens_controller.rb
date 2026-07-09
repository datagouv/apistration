class Editor::TokensController < EditorController
  def index
    @editor_tokens = current_editor.tokens.order(created_at: :desc)
  end

  def edit
    @editor_token = authorize(token, :update?)
  end

  def create
    authorize EditorToken

    @editor_token = current_editor.tokens.create!

    render :created
  end

  def update
    @editor_token = authorize(token, :update?)

    if @editor_token.update(params.expect(editor_token: [:allowed_ips_text]))
      redirect_to editor_tokens_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  def rotate
    @editor_token = authorize(token, :rotate?).rotate!

    render :created
  end

  def revoke
    authorize(token, :revoke?).revoke!

    redirect_to editor_tokens_path
  end

  private

  def token
    current_editor.tokens.find(params.expect(:id))
  end
end
