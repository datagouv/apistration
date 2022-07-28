class APIPolicy
  attr_reader :user, :resource

  class AccessForbiddenError < StandardError; end

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def show?
    user_authorized?
  end

  private

  def user_authorized?
    user.has_access?(jwt_scope_tag)
  end

  def jwt_scope_tag
    fail 'Child implementation needed'
  end
end
