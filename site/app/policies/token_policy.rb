class TokenPolicy < ApplicationPolicy
  alias token record

  def ask_for_prolongation?
    !demandeur? && day_left < 90
  end

  def show?
    contact?
  end

  def revoke?
    contact? && token.active?
  end

  def transfer?
    contact? && token.active?
  end

  def prolong?
    demandeur? && day_left < 90 && !token.blacklisted?
  end

  private

  def contact?
    authorization_request.users.include?(user)
  end

  def demandeur?
    authorization_request.demandeur == user
  end

  def authorization_request
    @authorization_request ||= token.authorization_request
  end

  def day_left
    (token.end_timestamp - Time.zone.now.to_i) / 1.day
  end
end
