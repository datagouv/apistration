class APIParticulier::V2::CNAF::QuotientFamilialController < APIParticulier::V2::BaseController
  def show
    organizer = retrieve_payload_data(::CNAF::QuotientFamilial, cache: true, expires_in: 24.hours)

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
      beneficiary_number: params[:numeroAllocataire],
      postal_code: params[:codePostal]
    }
  end
end
