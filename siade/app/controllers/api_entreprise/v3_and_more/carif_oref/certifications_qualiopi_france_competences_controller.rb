class APIEntreprise::V3AndMore::CarifOref::CertificationsQualiopiFranceCompetencesController < APIEntreprise::V3AndMore::BaseController
  nomenclature organizers: { 3 => ::CarifOref::CertificationsQualiopiFranceCompetences }

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end

  def serializer_module
    ::APIEntreprise::CarifOref::CertificationsQualiopiFranceCompetencesSerializer
  end

  def operation_id
    'api_entreprise_v3_carif_oref_certifications_qualiopi_france_competences'
  end

  def organizer
    @organizer ||= retrieve_payload_data(::CarifOref::CertificationsQualiopiFranceCompetences)
  end
end
