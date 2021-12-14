class INPI::Brevets < RetrieverOrganizer
  organize ValidateSiren,
    INPI::Brevets::ValidateLimit,
    INPI::Brevets::MakeRequest,
    INPI::Brevets::ValidateResponse,
    INPI::Brevets::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
