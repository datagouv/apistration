class APIParticulier::V3AndMore::CNAV::RevenuSolidariteActiveWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  def organizer_class
    CNAV::RevenuSolidariteActive
  end

  def serializer_module
    ::APIParticulier::CNAV::RevenuSolidariteActive
  end
end
