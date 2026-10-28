class Token::RevokeToken < ApplicationInteractor
  def call
    context.token.with_lock do
      context.fail!(message: 'Token already revoked') unless context.token.active?

      context.token.revoke!
    end
  end
end
