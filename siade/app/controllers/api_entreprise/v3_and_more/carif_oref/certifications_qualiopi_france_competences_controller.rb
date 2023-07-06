class APIEntreprise::V3AndMore::CarifOref::CertificationsQualiopiFranceCompetencesController < APIEntreprise::V3AndMore::MockedController
  def show
    organizer = retrieve_payload_data(::CarifOref::CertificationsQualiopiFranceCompetences)

    if organizer.success?
      render json: organizer[:payload],
        status: organizer[:status]
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

  def verify_api_version!
    true
  end

  def operation_id
    'api_entreprise_v3_carif_oref_certifications_qualiopi_france_competences'
  end
end
