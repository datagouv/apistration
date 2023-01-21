class APIParticulier::V2::CNAF::QuotientFamilialController < APIParticulierController
  def show
    organizer = retrieve_payload_data(::CNAF::QuotientFamilial)

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
