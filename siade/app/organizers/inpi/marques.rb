class INPI::Marques < RetrieverOrganizer
  organize ValidateSiren,
    INPI::ValidateLimit,
    INPI::Marques::MakeRequest,
    INPI::Marques::ValidateResponse,
    INPI::Marques::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
