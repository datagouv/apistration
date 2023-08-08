class Qualifelec::Certificats < RetrieverOrganizer
  organize ValidateSiret,
    Qualifelec::Certificats::Authenticate,
    Qualifelec::Certificats::MakeRequest,
    Qualifelec::Certificats::ValidateResponse,
    Qualifelec::Certificats::BuildResourceCollection

  def provider_name
    'Qualifelec'
  end
end
