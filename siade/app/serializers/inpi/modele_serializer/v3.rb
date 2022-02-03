class INPI::ModeleSerializer::V3 < JSONAPI::BaseSerializer
  set_type :modele

  link :notice, :notice_url

  attributes :numero_depot,
    :titre,
    :total_representations,
    :deposant,
    :date_depot,
    :date_publication,
    :classe,
    :reference
end
