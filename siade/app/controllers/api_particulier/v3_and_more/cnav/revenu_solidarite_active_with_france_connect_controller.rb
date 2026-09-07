class APIParticulier::V3AndMore::CNAV::RevenuSolidariteActiveWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  nomenclature organizers: { 3 => ::CNAV::RevenuSolidariteActive }

  private

  def organizer_class
    CNAV::RevenuSolidariteActive
  end

  def serializer_module
    ::APIParticulier::CNAV::RevenuSolidariteActive
  end
end
