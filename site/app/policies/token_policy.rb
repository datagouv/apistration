class TokenPolicy < ApplicationPolicy
  alias token record

  def show?
    contact?
  end

  def revoke?
    contact? && token.active?
  end

  def transfer?
    contact? && token.active?
  end

  def extend?
    contact? &&
      token.active? &&
      token.exp <= Token::EXTENSION_WINDOW.from_now.to_i &&
      authorization_request.eligible_for_token_creation?
  end

  private

  def contact?
    authorization_request.users.include?(user)
  end

  def authorization_request
    @authorization_request ||= token.authorization_request
  end
end
