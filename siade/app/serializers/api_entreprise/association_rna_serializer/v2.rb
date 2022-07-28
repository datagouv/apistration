class APIEntreprise::AssociationRNASerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :id,
    :titre,
    :objet,
    :siret,
    :siret_siege_social,
    :date_creation,
    :date_declaration,
    :date_publication,
    :date_dissolution,
    :adresse_siege,
    :code_civilite_dirigeant,
    :civilite_dirigeant,
    :code_etat,
    :etat,
    :code_groupement,
    :groupement,
    :mise_a_jour
end
