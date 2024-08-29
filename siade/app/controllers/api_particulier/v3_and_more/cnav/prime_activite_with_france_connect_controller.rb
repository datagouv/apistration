class APIParticulier::V3AndMore::CNAV::PrimeActiviteWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::PrimeActivite
  end

  def serializer_module
    ::APIParticulier::CNAV::PrimeActivite
  end
end
