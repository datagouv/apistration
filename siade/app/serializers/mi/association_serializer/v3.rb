class MI::AssociationSerializer::V3 < V3AndMore::BaseSerializer
  attributes :titre,
    :objet,
    :siret,
    :siret_siege_social,
    :date_creation,
    :date_declaration,
    :date_publication,
    :date_dissolution,
    :adresse_siege,
    :etat,
    :groupement,
    :mise_a_jour
end
