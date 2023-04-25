class APIEntreprise::GIPMDS::EffectifsMensuelsEtablissementSerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siret,
    :annee,
    :mois,
    :effectifs_mensuels

  def effectifs_mensuels
    count = valid_effectifs.sum do |data|
      data[:value].to_f
    end

    format('%.2f', count)
  end

  private

  def valid_effectifs
    object.effectifs_mensuel.values.select do |data|
      data[:value].present?
    end
  end
end
