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

  # rubocop:disable Metrics/MethodLength
  def extract_http_code(retriever)
    if retriever.errors.blank?
      :ok
    elsif at_least_one_error_kind_of?(:wrong_parameter, retriever)
      :unprocessable_entity
    elsif at_least_one_error_kind_of?(:network_error, retriever)
      :gateway_timeout
    elsif at_least_one_error_kind_of?(:unavailable_for_legal_reason, retriever)
      :unavailable_for_legal_reasons
    elsif at_least_one_error_kind_of?(:unauthorized, retriever)
      :unauthorized
    elsif at_least_one_error_kind_of?(:not_found, retriever)
      :not_found
    elsif at_least_one_error_kind_of?(:provider_error, retriever)
      :bad_gateway
    elsif at_least_one_error_kind_of?(:internal_error, retriever)
      :internal_error
    else
      raise 'No valid HTTP status'
    end
  end
end
