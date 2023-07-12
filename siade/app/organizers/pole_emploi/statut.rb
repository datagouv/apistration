class PoleEmploi::Statut < RetrieverOrganizer
  organize PoleEmploi::ValidateParams,
    PoleEmploi::Authenticate,
    PoleEmploi::Statut::MakeRequest,
    PoleEmploi::Statut::ValidateResponse,
    PoleEmploi::Statut::BuildResource

  def provider_name
    'Pôle Emploi'
  end
end
