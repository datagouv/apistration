class AttestationAGEFIPHPolicy < APIPolicy
  def jwt_role_tag
    'attestations_agefiph'
  end
end
