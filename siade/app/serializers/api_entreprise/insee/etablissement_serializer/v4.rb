class APIEntreprise::INSEE::EtablissementSerializer::V4 < APIEntreprise::INSEE::EtablissementSerializer::V3
  attributes :activite_principale_naf_rev2

  attribute :activite_principale do
    data.activite_principale
  end

  attribute :unite_legale do
    data.unite_legale.to_h.except(
      :id,
      :date_cessation,
      :date_derniere_mise_a_jour,
      :redirect_from_siren
    )
  end

  link :unite_legale do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/unites_legales',
      action: :show,
      api_version: '4',
      siren: data.siren
    )
  end
end
