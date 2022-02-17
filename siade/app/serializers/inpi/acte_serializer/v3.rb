class INPI::ActeSerializer::V3 < JSONAPI::BaseSerializer
  set_type :acte

  link :greffe, :greffe_url

  attributes :siren,
    :code_greffe,
    :date_depot,
    :nature_archive
end
