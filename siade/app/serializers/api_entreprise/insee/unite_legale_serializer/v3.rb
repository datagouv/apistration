class APIEntreprise::INSEE::UniteLegaleSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siren,
    :rna,
    :siret_siege_social,
    :categorie_entreprise,
    :type,
    :personne_morale_attributs,
    :personne_physique_attributs,
    :diffusable_commercialement,
    :status_diffusion,
    :forme_juridique,
    :activite_principale,
    :tranche_effectif_salarie,
    :etat_administratif,
    :economie_sociale_et_solidaire,
    :date_cessation,
    :date_creation

  attribute :activite_principale do
    data.activite_principale_naf_rev2
  end

  link :siege_social do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/etablissements',
      action: :show,
      api_version: '3',
      siret: data.siret_siege_social
    )
  end

  link :siege_social_adresse do
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/adresses_etablissements',
      action: :show,
      api_version: '3',
      siret: data.siret_siege_social
    )
  end

  meta do |ctx|
    {
      date_derniere_mise_a_jour: ctx.date_derniere_mise_a_jour,
      redirect_from_siren: ctx.redirect_from_siren
    }
  end
end
