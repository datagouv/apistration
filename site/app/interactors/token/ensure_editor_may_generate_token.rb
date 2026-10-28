class Token::EnsureEditorMayGenerateToken < ApplicationInteractor
  def call
    context.fail!(message: I18n.t('editor.authorization_request_tokens.create.error.not_allowed')) unless allowed?
  end

  private

  def allowed?
    context.editor.copy_token? && context.authorization_request.latest_active_token.nil?
  end
end
