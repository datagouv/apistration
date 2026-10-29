class APIEntreprise::V3AndMore::PROBTP::AttestationsCotisationRetraiteController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::PROBTP::AttestationsCotisationsRetraite }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::PROBTP::AttestationCotisationRetraiteSerializer
  end

  def organizer
    @organizer ||= retrieve_payload_data(::PROBTP::AttestationsCotisationsRetraite)
  end
end
