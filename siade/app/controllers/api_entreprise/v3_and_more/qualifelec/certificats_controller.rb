class APIEntreprise::V3AndMore::Qualifelec::CertificatsController < APIEntreprise::V3AndMore::MockedController
  def show
    organizer = retrieve_payload_data(::Qualifelec::Certificats)

    if organizer.success?
      render json: organizer[:payload], status: organizer[:status]
    else
      render_errors(organizer)
    end
  end

  protected

  def organizer_params
    {
      siret: params[:siret]
    }
  end

  def verify_api_version!
    true
  end

  def operation_id
    'api_entreprise_v3_qualifelec_certificats'
  end
end
