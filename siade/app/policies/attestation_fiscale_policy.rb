class AttestationFiscalePolicy < APIPolicy
  def jwt_role_tag
    'attestations_fiscales'
  end
end
