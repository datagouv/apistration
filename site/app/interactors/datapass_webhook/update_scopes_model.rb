class DatapassWebhook::UpdateScopesModel < ApplicationInteractor
  include DatapassWebhook::PassScopes

  before do
    context.modalities ||= %w[params]
  end

  def call
    return if %w[approve validate].exclude?(context.event)
    return if context.modalities.exclude?('params')

    scopes = pass_scopes

    ActiveRecord::Base.transaction do
      authorization_request.update!(scopes:)
      context.updated_tokens = update_active_tokens(scopes)
    end
  end

  private

  def update_active_tokens(scopes)
    authorization_request.tokens.active.to_a.each { |token| token.update!(scopes:) }
  end

  def authorization_request
    context.authorization_request
  end
end
