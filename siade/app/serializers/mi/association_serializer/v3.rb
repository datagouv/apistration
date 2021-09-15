class MI::AssociationSerializer::V3 < JSONAPI::BaseSerializer
  set_type :association

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
