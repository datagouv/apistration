class APIParticulier::V3AndMore::CNAV::PrimeActiviteWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::PrimeActivite }

  def organizer_class
    CNAV::PrimeActivite
  end

  def serializer_module
    ::APIParticulier::CNAV::PrimeActivite
  end
end
