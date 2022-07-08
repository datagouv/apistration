class EtablissementPolicy < APIPolicy
  alias show_with_non_diffusables? show?

  def jwt_scope_tag
    'etablissements'
  end
end
