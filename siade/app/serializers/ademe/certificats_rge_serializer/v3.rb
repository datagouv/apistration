class ADEME::CertificatsRGESerializer::V3 < JSONAPI::BaseSerializer
  set_type :certificats_rge

  attributes :entreprise,
    :certificats
end
