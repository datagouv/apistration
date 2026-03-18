class LiasseFiscalePolicy < APIPolicy
  alias declaration? show?
  alias dictionnaire? show?

  def jwt_role_tag
    'liasse_fiscale'
  end
end
