class BilansINPIPolicy < APIPolicy
  alias bilans? show?

  def jwt_scope_tag
    'bilans_inpi'
  end

  # TODO: drop me rôle INPI in 2022/06
  def user_authorized?
    user.has_access?(jwt_scope_tag) || user.has_access?(old_jwt_scope_tag)
  end

  def old_jwt_scope_tag
    'actes_bilans_inpi'
  end
end
