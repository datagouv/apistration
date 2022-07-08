class AttestationAGEFIPHPolicy < APIPolicy
  def jwt_scope_tag
    'attestations_agefiph'
  end
end
