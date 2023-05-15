class APIParticulier::MEN::Scolarites::V2 < APIParticulier::V2BaseSerializer
  attributes :eleve,
    :code_etablissement,
    :annee_scolaire,
    :est_scolarise,
    :est_boursier,
    :status_eleve
end
