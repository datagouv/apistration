class APIParticulier::V3AndMore::CNAV::FoyerRSAWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::FoyerRSA }

  private

  def organizer_class
    CNAV::FoyerRSA
  end

  def serializer_module
    ::APIParticulier::CNAV::FoyerRSASerializer
  end
end
