class AttestationFiscalePolicy < APIPolicy
  def jwt_scope_tag
    'attestations_fiscales'
  end
end
