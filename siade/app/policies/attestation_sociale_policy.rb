class AttestationSocialePolicy < APIPolicy
  def jwt_role_tag
    'attestations_sociales'
  end
end
