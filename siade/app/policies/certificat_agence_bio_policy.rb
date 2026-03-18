class CertificatAgenceBIOPolicy < APIPolicy
  def jwt_role_tag
    'certificat_agence_bio'
  end
end
