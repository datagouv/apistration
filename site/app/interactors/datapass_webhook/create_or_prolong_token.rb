class DatapassWebhook::CreateOrProlongToken < ApplicationInteractor
  include DatapassWebhook::PassScopes

  before do
    context.modalities ||= %w[params]
  end

  def call
    return if %w[approve validate].exclude?(context.event)
    return if context.modalities.exclude?('params')

    token = create_or_prolong_token

    if token.persisted?
      affect_scopes(token)
      context.token_id = token.id
    else
      context.fail!(message: 'Fail to create token')
    end
  end

  private

  def create_or_prolong_token
    if token_already_exists?
      prolong_token!
      context.authorization_request.token
    else
      create_token
    end
  end

  def prolong_token!
    prolong_token_wizard = context.authorization_request.token.last_prolong_token_wizard

    if prolong_token_wizard.nil?
      context.authorization_request.token.prolong!
    elsif prolong_token_wizard.after?(:finished)
      prolong_token_wizard.prolong!
    else
      prolong_token_wizard.close_unfinished!
      context.authorization_request.token.prolong!
    end
  end

  def create_token
    authorization_request.tokens.create(
      Token.default_create_params.merge(
        context.token_create_extra_params || {}
      )
    )
  end

  def affect_scopes(token)
    computed_scopes = pass_scopes
    token.update!(scopes: computed_scopes)
    authorization_request.update!(scopes: computed_scopes)
  end

  def token_already_exists?
    context.authorization_request.token.present?
  end

  def authorization_request
    context.authorization_request
  end
end
