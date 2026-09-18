class APIParticulier::V3AndMore::CNAV::ComplementaireSanteSolidaireWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::ComplementaireSanteSolidaire }

  private

  def organizer_class
    CNAV::ComplementaireSanteSolidaire
  end

  def serializer_module
    ::APIParticulier::CNAV::ComplementaireSanteSolidaire
  end
end
