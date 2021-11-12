class Douanes::EORI < RetrieverOrganizer
  organize ValidateSiretOrEORI,
    Douanes::EORI::MakeRequest,
    Douanes::EORI::ValidateResponse,
    Douanes::EORI::BuildResource

  def provider_name
    'Douanes'
  end
end
