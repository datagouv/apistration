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

  private

  def contact?
    authorization_request.users.include?(user)
  end

  def authorization_request
    @authorization_request ||= token.authorization_request
  end
end
