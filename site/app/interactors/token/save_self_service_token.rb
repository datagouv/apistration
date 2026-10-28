class Token::SaveSelfServiceToken < ApplicationInteractor
  def call
    context.authorization_request.with_lock do
      context.token = context.created_token = build_token

      context.fail!(message: token.errors.full_messages.to_sentence) unless token.save(context: :self_service)
    end
  end

  private

  def token = context.token

  def build_token
    Token.build_for_self_service(
      context.authorization_request,
      creator: context.user,
      name: context.name,
      lifetime_in_months: context.lifetime_in_months,
      allowed_ips_text: context.allowed_ips_text
    )
  end
end
