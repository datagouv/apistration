class MSACotisationPolicy < APIPolicy
  def jwt_scope_tag
    'msa_cotisations'
  end
end
