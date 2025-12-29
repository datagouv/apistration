class APIEntreprise::MI::UniteLegaleSerializer::SharedV4 < APIEntreprise::V3AndMore::BaseSerializer
  %i[
    rna
    ancien_id
    siren
    nom
    sigle
    reconnue_utilite_publique
    siret_siege
    forme_juridique
    regime
    groupement
    eligibilite_cec
    raison_non_eligibilite_cec
    alsace_moselle
    impots_commerciaux
    date_dissolution
    date_publication_reconnue_utilite_publique
    date_publication_journal_officiel
  ].each do |attr|
    attribute attr do
      data.identite[attr]
    end
  end

  attribute :active do
    data.identite[:active] &&
      data.identite[:active_sirene]
  end

  attribute :date_creation do
    data.identite[:date_creation_rna] ||
      data.identite[:date_creation_sirene]
  end

  attributes :adresse_siege,
    :composition_reseau,
    :agrements,
    :adresse_gestion,
    :activites

  link :insee_siege_social do
    next unless data.identite[:siret_siege]

    url_for(
      controller: 'api_entreprise/v3_and_more/insee/etablissements',
      action: :show,
      api_version: '3',
      siret: data.identite[:siret_siege]
    )
  end

  link :insee_siege_social_adresse do
    next unless data.identite[:siret_siege]

    url_for(
      controller: 'api_entreprise/v3_and_more/insee/adresses_etablissements',
      action: :show,
      api_version: '3',
      siret: data.identite[:siret_siege]
    )
  end

  meta do |ctx|
    {
      internal_id: ctx.identite[:internal_id],
      date_derniere_mise_a_jour_sirene: ctx.identite[:date_derniere_mise_a_jour_sirene],
      date_derniere_mise_a_jour_rna: ctx.identite[:date_derniere_mise_a_jour_rna]
    }
  end
end
