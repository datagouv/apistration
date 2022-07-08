class BilansEntrepriseBDFPolicy < APIPolicy
  def jwt_scope_tag
    'bilans_entreprise_bdf'
  end
end
