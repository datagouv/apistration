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

  attribute :activite_principale do
    data.activite_principale_naf_rev2
  end

  attribute :unite_legale do
    unite_legale_hash = data.unite_legale.to_h.except(
      :id,
      :date_cessation,
      :date_derniere_mise_a_jour,
      :redirect_from_siren,
      :activite_principale_naf_rev2
    )
    unite_legale_hash[:activite_principale] = data.unite_legale.activite_principale_naf_rev2
    unite_legale_hash
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
