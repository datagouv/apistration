class APIEntreprise::Infogreffe::MandatairesSociaux::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  item_serializer do |item|
    if item.type == 'personne_physique'
      APIEntreprise::Infogreffe::MandatairesSociaux::PersonnePhysiqueSerializer::V3
    else
      APIEntreprise::Infogreffe::MandatairesSociaux::PersonneMoraleSerializer::V3
    end
  end

  meta do |ctx|
    {
      personnes_physiques_count: ctx[:personnes_physiques_count],
      personnes_morales_count: ctx[:personnes_morales_count],
      count: ctx[:count]
    }
  end
end
