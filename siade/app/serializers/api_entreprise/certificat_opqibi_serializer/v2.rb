class APIEntreprise::CertificatOPQIBISerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siren,
    :numero_certificat,
    :date_de_delivrance_du_certificat,
    :duree_de_validite_du_certificat,
    :assurance,
    :url,
    :qualifications,
    :date_de_validite_des_qualifications,
    :qualifications_probatoires,
    :date_de_validite_des_qualifications_probatoires
end
