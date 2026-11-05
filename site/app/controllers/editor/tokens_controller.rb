class Editor::TokensController < EditorController
  before_action :ensure_editor_tokens_enabled, except: :index

  def index
    return render :disabled unless current_editor.editor_tokens_enabled?

    @editor_tokens = current_editor.tokens.order(created_at: :desc)
  end

  def edit
    @editor_token = authorize(token, :update?)
  end

  def create
    authorize EditorToken

    result = EditorToken::Create.call(editor: current_editor)
    @editor_token = result.editor_token

    if result.success?
      render :created
    else
      redirect_with_errors(@editor_token)
    end
  end

  def update
    @editor_token = authorize(token, :update?)

    result = EditorToken::UpdateAllowedIps.call(editor_token: @editor_token, allowed_ips_text: allowed_ips_params[:allowed_ips_text])

    if result.success?
      redirect_to editor_tokens_path
    else
      render :edit, status: :unprocessable_content
    end
  end

  def rotate
    result = EditorToken::Rotate.call(editor_token: authorize(token, :rotate?))
    @editor_token = result.replacement

    if result.success?
      render :created
    else
      redirect_with_errors(@editor_token)
    end
  end

  def revoke
    EditorToken::Revoke.call(editor_token: authorize(token, :revoke?))

    redirect_to editor_tokens_path
  end

  private

  def allowed_ips_params
    params.expect(editor_token: [:allowed_ips_text])
  end

  def redirect_with_errors(editor_token)
    error_message(
      title: t('editor.tokens.errors.invalid_allowed_ips'),
      description: editor_token.errors.full_messages.to_sentence
    )

    redirect_to editor_tokens_path
  end

  def ensure_editor_tokens_enabled
    redirect_to editor_tokens_path unless current_editor.editor_tokens_enabled?
  end

  def token
    current_editor.tokens.find(params.expect(:id))
  end
end
