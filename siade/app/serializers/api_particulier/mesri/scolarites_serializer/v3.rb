class APIParticulier::MESRI::ScolaritesSerializer::V3 < APIParticulier::V3AndMore::BaseSerializer
  attributes :eleve,
    :code_etablissement,
    :annee_scolaire,
    :est_scolarise,
    :est_boursier,
    :code_status_eleve
end
