class INPI::Actes < RetrieverOrganizer
  organize ValidateSiren,
    INPI::Authenticate,
    INPI::Actes::MakeRequest,
    INPI::Actes::ValidateResponse,
    INPI::Actes::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
