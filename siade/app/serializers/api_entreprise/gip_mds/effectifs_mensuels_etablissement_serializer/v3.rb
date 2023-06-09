class APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siret

  attribute :effectifs_mensuels do |object|
    object.effectifs_mensuels.map do |effectif|
      {
        regime: effectif[:regime],
        annee: effectif[:year],
        mois: effectif[:month],
        value: effectif[:value],
        date_derniere_mise_a_jour: effectif[:date_derniere_mise_a_jour]
      }
    end
  end
end
