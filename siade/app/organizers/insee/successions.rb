class INSEE::Successions < RetrieverOrganizer
  organize ValidateSiret,
    INSEE::Authenticate,
    INSEE::Successions::MakeRequest,
    INSEE::Successions::ValidateResponse,
    INSEE::Successions::BuildResource

  def provider_name
    'INSEE'
  end
end
