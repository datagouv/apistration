class APIEntreprise::INSEE::EtablissementSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret,
    :siege_social,
    :etat_administratif,
    :date_fermeture,
    :enseigne,
    :activite_principale,
    :tranche_effectif_salarie,
    :diffusable_commercialement,
    :date_creation

  attribute :unite_legale do |object|
    object.unite_legale.to_h.except(
      :id,
      :date_cessation
    )
  end

  attribute :adresse do |object|
    object.adresse.to_h.except(
      :id,
      :siren,
      :date_derniere_mise_a_jour
    )
  end

  link :unite_legale do |object|
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/unites_legales',
      action: :show,
      api_version: '3',
      siren: object.siren
    )
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour,
      redirect_from_siret: object.redirect_from_siret
    }
  end
end
