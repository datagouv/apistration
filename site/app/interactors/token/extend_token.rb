class Token::ExtendToken < ApplicationInteractor
  def call
    token.authorization_request.with_lock do
      token.lock!
      ensure_extendable!
      extend_token!
    end
  end

  private

  def ensure_extendable!
    context.fail!(message: 'Token can no longer be extended') unless TokenPolicy.new(context.user, token).extend?
  end

  def extend_token!
    token.extend_by!(context.lifetime_in_months)
  rescue ActiveRecord::RecordInvalid => e
    context.fail!(message: e.record.errors.full_messages.to_sentence)
  end

  def token = context.token
end
