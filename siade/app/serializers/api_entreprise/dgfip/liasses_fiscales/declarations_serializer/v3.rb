class APIEntreprise::DGFIP::LiassesFiscales::DeclarationsSerializer::V3 < APIEntreprise::V3AndMore::BaseSerializer
  attributes :obligations_fiscales,
    :declarations

  meta do |object|
    {
      internal_id_itip: object.internal_id_itip
    }
  end
end
