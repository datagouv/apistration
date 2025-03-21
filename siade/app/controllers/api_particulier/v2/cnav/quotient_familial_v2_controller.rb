class APIParticulier::V2::CNAV::QuotientFamilialV2Controller < APIParticulier::V2::CNAV::AbstractController
  protected

  def operation_id
    'api_particulier_v2_cnav_quotient_familial_v2'
  end

  def user_identity_params
    super.merge({
      annee: params[:annee],
      mois: params[:mois]
    })
  end

  def retriever
    ::CNAV::QuotientFamilialV2
  end

  def expires_in
    24.hours
  end

  def api_name
    'quotient_familial'
  end

  private

  def extract_http_code(organizer)
    if at_least_one_error_kind_of?(:wrong_parameter, organizer)
      :bad_request
    elsif at_least_one_error_kind_of?(%i[provider_error provider_unknown_error], organizer)
      :service_unavailable
    else
      super
    end
  end

  def format_wrong_parameter_error(error)
    {
      error: error.field == :sngi ? 'not_found' : 'bad_request',
      reason: error.detail,
      message: error.detail
    }
  end
end
