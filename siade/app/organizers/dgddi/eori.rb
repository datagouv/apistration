class DGDDI::EORI < RetrieverOrganizer
  organize ValidateSiretOrEORI,
    DGDDI::EORI::MakeRequest,
    DGDDI::EORI::ValidateResponse,
    DGDDI::EORI::BuildResource

  def provider_name
    'DGDDI'
  end
end
