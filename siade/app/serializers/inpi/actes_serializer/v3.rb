class INPI::ActesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :actes

  attributes :siren,
    :code_greffe,
    :date_depot,
    :nature_archive
end
