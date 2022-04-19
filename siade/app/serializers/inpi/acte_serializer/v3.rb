class INPI::ActeSerializer::V3 < V3AndMore::BaseSerializer
  link :greffe, &:greffe_url

  attributes :siren,
    :code_greffe,
    :date_depot,
    :nature_archive
end
