class EditorToken::CreateModel < ApplicationInteractor
  def call
    context.editor_token = context.editor.tokens.new

    context.fail! unless context.editor_token.save
  end
end
