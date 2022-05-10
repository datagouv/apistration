class API::V2::CertificatsRGEADEMEController < API::V2::BaseController
  def show
    authorize :certificat_rge_ademe

    organizer = ::ADEME::CertificatsRGE.call(params: organizer_params)

    if organizer.success?
      render json: CertificatRGEADEMESerializer.new(organizer.resource_collection).as_json,
        status: extract_http_code(organizer)
    else
      render json: ErrorsSerializer.new(organizer.errors, format: :json_api).as_json,
      status: extract_http_code(organizer)
    end
  end

  def request_params
    params.require(:siret)
  end

  private

  def organizer_params
    {
      siret: params.require(:siret),
      limit: params[:limit]
    }
  end
end
