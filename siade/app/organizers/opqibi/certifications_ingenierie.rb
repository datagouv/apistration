class OPQIBI::CertificationsIngenierie < RetrieverOrganizer
  organize ValidateSiren,
    OPQIBI::CertificationsIngenierie::MakeRequest,
    OPQIBI::CertificationsIngenierie::ValidateResponse,
    OPQIBI::CertificationsIngenierie::BuildResource

  def provider_name
    'OPQIBI'
  end
end
