class APIEntreprise::INSEE::AdresseEtablissementSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :numero_voie,
    :indice_repetition_voie,
    :type_voie,
    :libelle_voie,
    :complement_adresse,
    :code_commune,
    :libelle_commune,
    :code_postal,
    :distribution_speciale,
    :code_cedex,
    :libelle_cedex,
    :acheminement_postal,
    :libelle_commune_etranger,
    :code_pays_etranger,
    :libelle_pays_etranger

  link :unite_legale do |object|
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/unites_legales',
      action: :show,
      api_version: '3',
      siren: object.siren
    )
  end

  link :etablissement do |object|
    url_for(
      controller: 'api_entreprise/v3_and_more/insee/etablissements',
      action: :show,
      api_version: '3',
      siret: object.siret
    )
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour
    }
  end
end
