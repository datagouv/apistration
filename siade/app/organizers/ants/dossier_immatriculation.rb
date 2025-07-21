class ANTS::DossierImmatriculation < RetrieverOrganizer
  organize ANTS::DossierImmatriculation::ValidateParams,
    ANTS::DossierImmatriculation::MakeRequest

  def provider_name
    'ANTS'
  end
end
