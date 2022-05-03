class ADEME::CertificatRGESerializer::V3 < V3AndMore::BaseSerializer
  attributes :id_ademe,
    :url,
    :nom_certificat,
    :domaine,
    :meta_domaine,
    :code_qualification,
    :nom_qualification,
    :organisme,
    :date_attribution,
    :date_expiration,
    :updated_at
end
