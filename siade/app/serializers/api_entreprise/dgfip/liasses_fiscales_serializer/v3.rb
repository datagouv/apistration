class APIEntreprise::DGFIP::LiassesFiscalesSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :obligations_fiscales,
    :declarations

  meta do |ctx|
    {
      internal_id_itip: ctx.internal_id_itip
    }
  end
end
