class AuthorizationRequestPolicy < ApplicationPolicy
  alias authorization_request record

  def create_token?
    contact? &&
      authorization_request.eligible_for_token_creation? &&
      !authorization_request.active_tokens_limit_reached?
  end

  private

  def contact?
    authorization_request.users.include?(user)
  end
end
