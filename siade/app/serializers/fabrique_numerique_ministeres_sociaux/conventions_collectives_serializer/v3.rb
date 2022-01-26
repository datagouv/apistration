class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectivesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :collection

  attributes :numero_idcc,
    :titre,
    :titre_court,
    :active,
    :etat,
    :url,
    :synonymes,
    :date_publication
end
