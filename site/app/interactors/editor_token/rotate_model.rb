class EditorToken::RotateModel < ApplicationInteractor
  def call
    context.replacement = context.editor_token.rotate

    context.fail! unless context.replacement.persisted?
  end
end
