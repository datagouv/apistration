class CertificatAgenceBIOPolicy < APIPolicy
  def jwt_scope_tag
    'certificat_agence_bio'
  end
end
