class INSEE::AdresseEtablissementSerializer::V3 < JSONAPI::BaseSerializer
  set_type :adresse

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

  link :entreprise do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/entreprises/#{object.siren}"
  end

  link :etablissement do |object|
    "https://entreprises.api.gouv.fr/api/v3/insee/etablissements/#{object.id}"
  end

  meta do |object|
    {
      date_derniere_mise_a_jour: object.date_derniere_mise_a_jour
    }
  end
end
