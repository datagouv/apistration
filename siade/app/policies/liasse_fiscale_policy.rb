class LiasseFiscalePolicy < APIPolicy
  alias declaration? show?
  alias dictionnaire? show?

  def jwt_scope_tag
    'liasse_fiscale'
  end
end
