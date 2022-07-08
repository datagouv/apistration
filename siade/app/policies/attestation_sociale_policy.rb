class AttestationSocialePolicy < APIPolicy
  def jwt_scope_tag
    'attestations_sociales'
  end
end
