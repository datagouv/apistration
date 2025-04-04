class APIParticulier::V3AndMore::CNAV::ParticipationFamilialeAEJEWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::ParticipationFamilialeAEJE
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialeAEJE
  end
end
