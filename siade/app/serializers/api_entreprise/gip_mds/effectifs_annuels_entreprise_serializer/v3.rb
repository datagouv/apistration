class APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siren

  attribute :annee do
    data.effectifs_annuel.first[:year]
  end

  attribute :effectifs_annuel do
    data.effectifs_annuel.map do |effectif|
      effectif.except(:year, :month)
    end
  end
end
