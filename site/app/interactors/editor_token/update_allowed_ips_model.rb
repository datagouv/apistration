class EditorToken::UpdateAllowedIpsModel < ApplicationInteractor
  def call
    context.previous_allowed_ips = context.editor_token.allowed_ips_as_strings

    context.fail! unless context.editor_token.update(allowed_ips_text: context.allowed_ips_text)
  end
end
