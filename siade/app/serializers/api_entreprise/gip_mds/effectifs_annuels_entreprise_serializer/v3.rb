class APIEntreprise::GIPMDS::EffectifsAnnuelsEntrepriseSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :siren

  attribute :annee do |object|
    object.effectifs_annuel.first[:year]
  end

  attribute :effectifs_annuel do |object|
    {
      regime_general: find_regime('general', object),
      regime_agricole: find_regime('agricole', object)
    }
  end

  def self.find_regime(regime, object)
    object.effectifs_annuel.find { |effectif|
      effectif[:regime] == "regime_#{regime}"
    }.slice(:value, :date_derniere_mise_a_jour)
  end
end
