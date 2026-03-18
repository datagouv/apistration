class CertificatCNETPPolicy < APIPolicy
  def jwt_role_tag
    'certificat_cnetp'
  end
end
