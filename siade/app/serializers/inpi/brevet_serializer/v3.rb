class INPI::BrevetSerializer::V3 < V3AndMore::BaseSerializer
  set_type :brevet

  attributes :titre,
    :date_publication,
    :date_depot,
    :code_zone,
    :numero_brevet,
    :categorie_publication
end
