class APIParticulier::V3AndMore::CNAV::PrimeActiviteWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::PrimeActivite
  end

  def serializer_module
    ::APIParticulier::CNAV::PrimeActivite
  end
end
