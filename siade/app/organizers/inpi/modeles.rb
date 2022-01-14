class INPI::Modeles < RetrieverOrganizer
  organize ValidateSiren,
    INPI::ValidateLimit,
    INPI::Modeles::MakeRequest,
    INPI::ValidateResponse,
    INPI::Modeles::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
