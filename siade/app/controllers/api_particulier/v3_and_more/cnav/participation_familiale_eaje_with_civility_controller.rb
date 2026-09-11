class APIParticulier::V3AndMore::CNAV::ParticipationFamilialeEAJEWithCivilityController < APIParticulier::V3AndMore::CNAV::AbstractCivilityController
  nomenclature organizers: { 3 => ::CNAV::ParticipationFamilialeEAJE }

  private

  def organizer_class
    CNAV::ParticipationFamilialeEAJE
  end

  def serializer_module
    ::APIParticulier::CNAV::ParticipationFamilialeEAJE
  end
end
