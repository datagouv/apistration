class APIEntreprise::INSEE::EtablissementSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret,
    :siege_social,
    :etat_administratif,
    :date_fermeture,
    :enseigne,
    :activite_principale,
    :tranche_effectif_salarie,
    :diffusable_commercialement,
    :status_diffusion,
    :date_creation

  attribute :unite_legale do
    data.unite_legale.to_h.except(
      :id,
      :date_cessation,
      :date_derniere_mise_a_jour,
      :redirect_from_siren
    )
  end

  attribute :adresse do
    data.adresse.to_h.except(
      :id,
      :siren,
      :siret,
      :diffusable_commercialement,
      :type,
      :date_derniere_mise_a_jour
    )
  end

  link :unite_legale do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/unites_legales',
      action: :show,
      api_version: '3',
      siren: data.siren
    )
  end

  meta do |ctx|
    {
      date_derniere_mise_a_jour: ctx.date_derniere_mise_a_jour,
      redirect_from_siret: ctx.redirect_from_siret
    }
  end
end
