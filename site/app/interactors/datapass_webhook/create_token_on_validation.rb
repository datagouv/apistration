class DatapassWebhook::CreateTokenOnValidation < ApplicationInteractor
  def call
    return unless validation_with_params?

    authorization_request.with_lock do
      next if authorization_request.tokens.active.exists?

      create_token
      schedule_token_available_email
    end
  end

  private

  def validation_with_params?
    %w[approve validate].include?(context.event) && context.modalities.include?('params')
  end

  def create_token
    context.token = authorization_request.tokens.create!(Token.default_create_params.merge(scopes: authorization_request.scopes))
  end

  def schedule_token_available_email
    ScheduleAuthorizationRequestEmailJob.perform_later(
      authorization_request.id,
      authorization_request.status,
      'jeton_disponible',
      { to: authorization_request.users.map(&:email).compact_blank.uniq }
    )
  end

  def authorization_request
    context.authorization_request
  end
end
