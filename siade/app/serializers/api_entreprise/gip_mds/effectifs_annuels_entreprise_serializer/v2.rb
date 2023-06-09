class APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siren,
    :annee,
    :effectifs_annuel

  def effectifs_annuel
    format('%.2f', valid_effectif[:value])
  end

  def annee
    object.effectifs_annuel.first[:year]
  end

  private

  def valid_effectif
    object.effectifs_annuel.find do |effectif_annuel|
      effectif_annuel[:regime] == 'regime_general' &&
        effectif_annuel[:value].present?
    end
  end
end
