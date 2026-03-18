class PrivilegePolicy < APIPolicy
  def user_authorized?
    # no access needed
    true
  end

  def jwt_role_tag
    nil # no tag since it is open provided jwt is valid
  end
end
