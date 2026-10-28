class Admin::Tokens::CreateToken < ApplicationInteractor
  def call
    authorization_request.with_lock do
      context.fail!(message: "La demande n'est plus validée : il n'est pas possible d'y créer de jeton") unless authorization_request.eligible_for_token_creation?

      context.token = create_token
    end
  end

  private

  def create_token
    authorization_request.tokens.create!(
      Token.default_create_params.merge(
        exp: context.exp,
        scopes: authorization_request.scopes
      )
    )
  end

  def authorization_request
    context.authorization_request
  end
end
