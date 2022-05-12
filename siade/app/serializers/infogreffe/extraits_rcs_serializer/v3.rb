class Infogreffe::ExtraitsRCSSerializer::V3 < V3AndMore::BaseSerializer
  attributes :siren,
    :date_extrait,
    :date_immatriculation,
    :mandataires_sociaux,
    :observations,
    :nom_commercial,
    :adresse_siege,
    :etablissement_principal,
    :capital,
    :greffe,
    :personne_morale,
    :personne_physique
end
