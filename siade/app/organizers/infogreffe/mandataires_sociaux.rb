class Infogreffe::MandatairesSociaux < RetrieverOrganizer
  organize ValidateSiren,
    Infogreffe::MakeRequest,
    Infogreffe::ValidateResponse,
    Infogreffe::MandatairesSociaux::BuildResourceCollection

  def provider_name
    'Infogreffe'
  end
end
