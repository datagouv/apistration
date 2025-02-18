class APIParticulier::V3AndMore::CNAV::ParticipationFamilialPSUWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  private

  def organizer_class
    CNAV::ParticipationFamilialPSU
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialPSU
  end
end
