class Admin::EditorTokens::CreateToken < ApplicationInteractor
  def call
    context.editor_token = context.editor.tokens.create!(
      iat: Time.zone.now.to_i,
      exp: 18.months.from_now.to_i
    )
  end
end
