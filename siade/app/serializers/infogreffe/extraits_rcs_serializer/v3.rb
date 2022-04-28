class Infogreffe::ExtraitsRCSSerializer::V3 < V3AndMore::BaseSerializer
  attributes :date_extrait,
    :date_immatriculation,
    :mandataires_sociaux,
    :observations,
    :denomination,
    :nom_commercial,
    :forme_juridique,
    :code_forme_juridique,
    :adresse_siege,
    :etablissement_principal,
    :date_cloture_exercice_comptable,
    :date_fin_de_vie,
    :capital,
    :greffe,
    :code_greffe
end
