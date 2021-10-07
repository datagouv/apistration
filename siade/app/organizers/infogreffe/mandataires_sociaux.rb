class Infogreffe::MandatairesSociaux < RetrieverOrganizer
  organize ValidateSiren,
    Infogreffe::MandatairesSociaux::MakeRequest,
    Infogreffe::MandatairesSociaux::ValidateResponse,
    Infogreffe::MandatairesSociaux::BuildResource

  def provider_name
    'Infogreffe'
  end
end
