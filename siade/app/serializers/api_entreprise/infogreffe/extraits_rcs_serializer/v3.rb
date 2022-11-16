class APIEntreprise::Infogreffe::ExtraitsRCSSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siren,
    :date_extrait,
    :date_radiation,
    :date_immatriculation,
    :mandataires_sociaux,
    :observations,
    :nom_commercial,
    :etablissement_principal,
    :capital,
    :greffe,
    :personne_morale,
    :personne_physique
end
