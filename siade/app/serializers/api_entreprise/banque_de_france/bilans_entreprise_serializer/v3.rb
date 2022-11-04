class APIEntreprise::BanqueDeFrance::BilansEntrepriseSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :annee,
      :date_arrete_exercice,
      :declarations,
      :valeurs_calculees
  end

  item_serializer ItemSerializer
end
