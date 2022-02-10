class Infogreffe::MandatairesSociaux < RetrieverOrganizer
  organize ValidateSiren,
    Infogreffe::MakeRequest,
    Infogreffe::MandatairesSociaux::ValidateResponse,
    Infogreffe::MandatairesSociaux::BuildResourceCollection

  def provider_name
    'Infogreffe'
  end
end
