class APIEntreprise::INSEE::UniteLegaleSerializer::V4 < APIEntreprise::INSEE::UniteLegaleSerializer::V3
  attributes :activite_principale_naf_rev2

  attribute :activite_principale do
    data.activite_principale
  end

  link :siege_social do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/etablissements',
      action: :show,
      api_version: '4',
      siret: data.siret_siege_social
    )
  end

  link :siege_social_adresse do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/adresses_etablissements',
      action: :show,
      api_version: '4',
      siret: data.siret_siege_social
    )
  end
end
