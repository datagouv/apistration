class APIParticulier::V2::CNAF::QuotientFamilialController < APIParticulier::V2::BaseController
  def show
    if organizer.success?
      render json: serialize_data,
        status: extract_http_code(organizer)
    else
      render_errors(organizer)
    end
  end

  private

  def organizer_params
    {
      beneficiary_number: params[:numeroAllocataire],
      postal_code: params[:codePostal]
    }
  end

  def organizer
    @organizer ||= retrieve_payload_data(::CNAF::QuotientFamilial, cache: true, expires_in: 24.hours)
  end
end
