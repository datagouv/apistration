class MSACotisationPolicy < APIPolicy
  def jwt_role_tag
    'msa_cotisations'
  end
end
