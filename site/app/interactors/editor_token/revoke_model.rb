class EditorToken::RevokeModel < ApplicationInteractor
  def call
    context.editor_token.revoke!
  end
end
