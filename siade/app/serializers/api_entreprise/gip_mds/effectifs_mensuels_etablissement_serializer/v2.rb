class APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siret,
    :annee,
    :mois,
    :effectifs_mensuels

  def effectifs_mensuels
    format('%.2f', valid_effectif[:value])
  end

  def annee
    object.effectifs_mensuels.first[:year]
  end

  def mois
    object.effectifs_mensuels.first[:month]
  end

  private

  def valid_effectif
    object.effectifs_mensuels.find do |effectif_mensuel|
      effectif_mensuel[:regime] == 'regime_general' &&
        effectif_mensuel[:value].present?
    end
  end
end
