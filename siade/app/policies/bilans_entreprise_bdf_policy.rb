class BilansEntrepriseBDFPolicy < APIPolicy
  def jwt_role_tag
    'bilans_entreprise_bdf'
  end
end
