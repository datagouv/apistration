class UptimePolicy < APIPolicy
  alias robot? show?

  def jwt_role_tag
    'uptime'
  end
end
