class APIParticulier::V3AndMore::CNAV::PrimeActiviteWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::PrimeActivite }

  private

  def organizer_class
    CNAV::PrimeActivite
  end

  def serializer_module
    ::APIParticulier::CNAV::PrimeActivite
  end
end
