class APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer::V2 < APIEntreprise::V2BaseSerializer
  attributes :siren,
    :annee,
    :effectifs_annuel

  def effectifs_annuel
    count = valid_effectifs.values.sum do |data|
      data[:value].to_f
    end

    format('%.2f', count)
  end

  private

  def valid_effectifs
    object.effectifs_annuel.select do |regime, data|
      regime == :regime_general &&
        data[:value].present?
    end
  end
end
