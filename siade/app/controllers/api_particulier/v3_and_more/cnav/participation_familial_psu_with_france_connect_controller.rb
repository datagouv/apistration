class APIParticulier::V3AndMore::CNAV::ParticipationFamilialPSUWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::ParticipationFamilialPSU
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialPSU
  end
end
