class APIEntreprise::INPI::RNE::BeneficiairesEffectifsSerializer::V3 < APIEntreprise::V3AndMore::BaseCollectionSerializer
  class ItemSerializer < APIEntreprise::V3AndMore::BaseSerializer
    attributes :beneficiaire_uuid,
      :nom,
      :nom_usage,
      :prenoms,
      :date_naissance,
      :nationalite,
      :pays_residence,
      :modalites
  end

  item_serializer ItemSerializer

  meta do |ctx|
    {
      count: ctx[:count],
      beneficiaires_sans_modalites_uuids: ctx[:beneficiaires_sans_modalites_uuids]
    }
  end
end
