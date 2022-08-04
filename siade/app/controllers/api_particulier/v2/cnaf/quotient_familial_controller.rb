class APIParticulier::V2::CNAF::QuotientFamilialController < APIParticulierController
  def show
    authorize :cnaf_quotient_familial, :cnaf_allocataires, :cnaf_enfants, :cnaf_adresse

    organizer = ::CNAF::QuotientFamilial.call(params: organizer_params)

    if organizer.success?
      render json: serializer_class.new(organizer.bundled_data.data, scope: current_user, scope_name: :current_user).serializable_hash,
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
