class ADEME::CertificatRGESerializer::V3 < V3AndMore::BaseSerializer
  attributes :url,
    :nom_certificat,
    :domaine,
    :meta_domaine,
    :qualification,
    :organisme,
    :date_attribution,
    :date_expiration,
    :meta
end
