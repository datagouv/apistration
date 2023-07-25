class APIEntreprise::INPI::RNE::BeneficiairesEffectifsSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :nom,
      :prenoms,
      :date_naissance,
      :modalites
  end

  item_serializer ItemSerializer

  meta do |ctx|
    {
      count: ctx[:count]
    }
  end
end
