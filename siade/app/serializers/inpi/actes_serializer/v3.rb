class INPI::ActesSerializer::V3 < JSONAPI::BaseSerializer
  set_type :actes

  attributes :siren,
    :denomination_sociale,
    :code_greffe,
    :date_depot,
    :nature_archive
end
