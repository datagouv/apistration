class APIPolicy
  attr_reader :user, :resource

  class AccessForbiddenError < StandardError; end

  def initialize(user, resource)
    @user = user
    @resource = resource
  end

  def show?
    log_user_access
    user_authorized?
  end

  private

  def log_user_access
    if user_authorized?
      UserAccessSpy.log_authorized(user:)
    else
      UserAccessSpy.log_forbidden_jwt_token(user:)
    end
  end

  def user_authorized?
    user.has_access?(jwt_role_tag)
  end

  def jwt_role_tag
    fail 'Child implementation needed'
  end
end
