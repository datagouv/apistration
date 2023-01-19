class APIEntreprise::MESRI::ScolariteSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :eleve,
    :code_etablissement,
    :annee_scolaire,
    :est_scolarise,
    :est_boursier,
    :code_status_eleve
end
