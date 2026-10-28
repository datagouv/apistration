class DatapassWebhook::UpdateScopes < ApplicationInteractor
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
      authorization_request.tokens.active.find_each { |token| token.update!(scopes:) }
    end
  end

  private

  def authorization_request
    context.authorization_request
  end
end
