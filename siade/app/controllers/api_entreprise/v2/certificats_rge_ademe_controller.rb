class APIEntreprise::V2::CertificatsRGEADEMEController < APIEntreprise::V2::BaseController
  def show
    authorize :certificat_rge_ademe

    organizer = ::ADEME::CertificatsRGE.call(params: organizer_params)

    if organizer.success?
      render json: APIEntreprise::CertificatRGEADEMESerializer.new(organizer.bundled_data.data).as_json,
        status: extract_http_code(organizer)
    else
      render json: ErrorsSerializer.new(organizer.errors, format: :json_api).as_json,
      status: extract_http_code(organizer)
    end
  end

  private

  def organizer_params
    {
      siret: params.require(:siret)
    }
  end
end
