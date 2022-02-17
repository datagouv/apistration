class Infogreffe::ExtraitsRCS < RetrieverOrganizer
  organize ValidateSiren,
    Infogreffe::MakeRequest,
    Infogreffe::ValidateResponse,
    Infogreffe::ExtraitsRCS::BuildResource

  def provider_name
    'Infogreffe'
  end
end
