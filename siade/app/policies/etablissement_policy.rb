class EtablissementPolicy < APIPolicy
  alias show_with_non_diffusables? show?

  def jwt_role_tag
    'etablissements'
  end
end


