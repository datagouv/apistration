class APIParticulier::V3AndMore::CNAV::RevenuSolidariteActiveWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::RevenuSolidariteActive
  end

  def serializer_module
    ::APIParticulier::CNAV::RevenuSolidariteActive
  end
end
