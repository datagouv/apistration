class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives < RetrieverOrganizer
  organize ValidateSiret,
    FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::MakeRequest,
    FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::ValidateResponse,
    FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::BuildResourceCollection

  def provider_name
    'Fabrique numérique des Ministères Sociaux'
  end
end
