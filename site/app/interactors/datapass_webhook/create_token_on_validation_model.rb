class DatapassWebhook::CreateTokenOnValidationModel < ApplicationInteractor
  before do
    context.modalities ||= %w[params]
  end

  def call
    return unless validation_with_params?

    authorization_request.with_lock do
      context.token_id = authorization_request.latest_active_token&.id
      create_token_and_announce_it if token_expected?
    end
  end

  private

  def validation_with_params?
    %w[approve validate].include?(context.event) && context.modalities.include?('params')
  end

  def token_expected?
    context.token_id.nil? && authorization_request.tokens.none? && !delegated_to_ready_editor?
  end

  def create_token_and_announce_it
    create_token
    schedule_token_available_email if context.announce_created_token
  end

  def delegated_to_ready_editor?
    authorization_request.editor_delegations.active.joins(:editor).merge(Editor.editor_tokens_ready).exists?
  end

  def create_token
    context.token = context.created_token = authorization_request.tokens.create!(Token.default_create_params.merge(scopes: authorization_request.scopes))
    context.token_id = context.created_token.id
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
