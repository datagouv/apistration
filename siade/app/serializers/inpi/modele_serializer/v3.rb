class INPI::ModeleSerializer::V3 < V3AndMore::BaseSerializer
  link :notice, &:notice_url

  attributes :document_id,
    :numero_depot,
    :titre,
    :total_representations,
    :deposant,
    :date_depot,
    :date_publication,
    :classe,
    :reference
end
