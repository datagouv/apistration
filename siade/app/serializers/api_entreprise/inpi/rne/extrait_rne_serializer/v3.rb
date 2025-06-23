class APIEntreprise::INPI::RNE::ExtraitRNESerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :document_url,
    :identite_entreprise,
    :dirigeants_et_associes,
    :etablissements,
    :diffusion_insee,
    :diffusion_commerciale,
    :etablissements_fermes_total,
    :observations
end
