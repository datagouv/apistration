class INPI::BrevetsSerializer::V3 < JSONAPI::BaseSerializer
  set_type :brevet

  attributes :id,
    :titre,
    :date_publication,
    :date_depot,
    :code_zone,
    :numero_brevet,
    :categorie_publication
end
