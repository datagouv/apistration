class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer::V3 < V3AndMore::BaseSerializer
  set_type :convention_collective

  attributes :numero_idcc,
    :titre,
    :titre_court,
    :active,
    :etat,
    :url,
    :synonymes,
    :date_publication
end
