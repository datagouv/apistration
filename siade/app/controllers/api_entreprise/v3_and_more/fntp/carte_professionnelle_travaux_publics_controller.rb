class APIEntreprise::V3AndMore::FNTP::CarteProfessionnelleTravauxPublicsController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::FNTP::CarteProfessionnelleTravauxPublics }

  private

  def organizer_params
    {
      siren: params.require(:siren)
    }
  end

  def serializer_module
    ::APIEntreprise::FNTP::CarteProfessionnelleTravauxPublicsSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::FNTP::CarteProfessionnelleTravauxPublics)
  end
end
