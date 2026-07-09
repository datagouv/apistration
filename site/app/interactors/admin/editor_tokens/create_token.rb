class Admin::EditorTokens::CreateToken < ApplicationInteractor
  def call
    context.editor_token = context.editor.tokens.create!
  end
end
