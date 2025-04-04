class APIParticulier::V3AndMore::CNAV::ParticipationFamilialeAEJEWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  private

  def organizer_class
    CNAV::ParticipationFamilialeAEJE
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialeAEJE
  end
end
