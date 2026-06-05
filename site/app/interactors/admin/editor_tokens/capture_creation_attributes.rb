class Admin::EditorTokens::CaptureCreationAttributes < ApplicationInteractor
  def call
    context.admin_after_attributes = { 'exp' => context.editor_token.exp }
  end
end
