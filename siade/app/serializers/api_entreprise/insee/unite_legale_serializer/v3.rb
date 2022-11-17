class APIEntreprise::INSEE::UniteLegaleSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siren,
    :siret_siege_social,
    :categorie_entreprise,
    :diffusable_commercialement,
    :type,
    :personne_morale_attributs,
    :personne_physique_attributs,
    :forme_juridique,
    :activite_principale,
    :tranche_effectif_salarie,
    :etat_administratif,
    :economie_sociale_et_solidaire,
    :date_cessation,
    :date_creation

  link :siege_social do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/etablissements/#{object.siret_siege_social}"
  end

  link :siege_social_adresse do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/etablissements/#{object.siret_siege_social}/adresse"
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour,
      redirect_from_siren: object.redirect_from_siren
    }
  end
end
