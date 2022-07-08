class UptimePolicy < APIPolicy
  alias robot? show?

  def jwt_scope_tag
    'uptime'
  end
end
