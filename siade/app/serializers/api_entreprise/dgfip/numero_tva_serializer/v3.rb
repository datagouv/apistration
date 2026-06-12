class APIEntreprise::DGFIP::NumeroTVASerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :numero_tva

  meta do |ctx|
    { date_derniere_mise_a_jour: ctx.date_derniere_mise_a_jour }
  end
end
