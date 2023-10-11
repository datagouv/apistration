class APIEntreprise::V3AndMore::CarifOref::CertificationsQualiopiFranceCompetencesController < APIEntreprise::V3AndMore::BaseController
  def show
    organizer = retrieve_payload_data(::CarifOref::CertificationsQualiopiFranceCompetences)

    if organizer.success?
      render json: serialize_data(organizer),
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
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
end
