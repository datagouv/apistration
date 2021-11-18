class INSEE::UniteLegaleSerializer::V3 < JSONAPI::BaseSerializer
  set_type :entreprise

  attributes :siret_siege_social,
    :categorie_entreprise,
    :numero_tva_intracommunautaire,
    :diffusable_commercialement,
    :type,
    :personne_morale_attributs,
    :personne_physique_attributs,
    :forme_juridique,
    :activite_principale,
    :tranche_effectif_salarie,
    :etat_administratif,
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
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour
    }
  end
end
