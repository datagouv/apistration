class INPI::Brevets < RetrieverOrganizer
  organize ValidateSiren,
    INPI::Brevets::MakeRequest,
    INPI::Brevets::ValidateResponse,
    INPI::Brevets::BuildResourceCollection

  def provider_name
    'INPI'
  end
end
