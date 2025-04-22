class APIParticulier::V3AndMore::CNAV::ParticipationFamilialeEAJEWithFranceConnectController < APIParticulier::V3AndMore::CNAV::AbstractFranceConnectController
  private

  def organizer_class
    CNAV::ParticipationFamilialeEAJE
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialeEAJE
  end
end
