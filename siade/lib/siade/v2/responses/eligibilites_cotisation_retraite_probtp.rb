class SIADE::V2::Responses::EligibilitesCotisationRetraitePROBTP < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'ProBTP'
  end

  def adapt_raw_response_code
    if etablissement_not_found?
      set_error_message_for(404)
    elsif unhandled_error?
      set_error_message_for(502)
    else
      @raw_response.code.to_i
    end
  end

  private

  def json_body
    @json_body ||= JSON.parse(@body, symbolize_names: true)
  end

  def internal_code
    json_body.dig(:entete, :code)
  end

  def internal_message
    json_body.dig(:entete, :message)
  end

  def unhandled_error?
    internal_code != '0'
  end

  def etablissement_not_found?
    internal_code == '8'
  end

  def set_error_message_502
    add_context_to_provider_error_tracking(
      internal_code: internal_code,
      internal_message: internal_message
    )
    @provider_error_custom_code = internal_code

    (@errors ||= []) << http_error_message
  end

  def http_error_message
    ProviderInternalServerError.new(
      provider_name,
      "Erreur interne du fournisseur de données (code: #{internal_code}, message: #{internal_message})"
    )
  end
end
