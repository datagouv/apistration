class DGFIP::LiassesFiscales::DeclarationsSerializer::V3 < V3AndMore::BaseSerializer
  set_type :liasses_fiscales

  attributes :obligations_fiscales,
    :declarations

  meta do |object|
    {
      internal_id_itip: object.internal_id_itip
    }
  end
end
