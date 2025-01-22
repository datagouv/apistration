class APIEntreprise::V3AndMore::CarifOref::CertificationsQualiopiFranceCompetencesController < APIEntreprise::V3AndMore::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors
    end
  end

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
