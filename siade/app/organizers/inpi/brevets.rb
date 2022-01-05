class INPI::Brevets < RetrieverOrganizer
  organize ValidateSiren,
    INPI::ValidateLimit,
    INPI::Brevets::MakeRequest,
    INPI::ValidateResponse,
    INPI::Brevets::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
