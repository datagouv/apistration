class OPQIBI::CertificationsIngenierieSerializer::V3 < JSONAPI::BaseSerializer
  set_type :certificat_ingenierie

  attributes :siren,
    :date_delivrance_certificat,
    :duree_validite_certificat,
    :assurances,
    :url,
    :qualifications,
    :date_validite_qualifications,
    :qualifications_probatoires,
    :date_validite_qualifications_probatoires
end
