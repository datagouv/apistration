class Qualifelec::Certificats < RetrieverOrganizer
  organize ValidateSiret,
    MockedInteractor

  def provider_name
    'Qualifelec'
  end
end
