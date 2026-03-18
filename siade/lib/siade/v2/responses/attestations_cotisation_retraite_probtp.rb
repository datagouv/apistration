class SIADE::V2::Responses::AttestationsCotisationRetraitePROBTP < SIADE::V2::Responses::Generic

  protected

  def provider_name
    'ProBTP'
  end

  def adapt_raw_response_code
    if http_internal_error? || invalid_json?
      set_error_message_for(502)
    elsif custom_internal_error?
      set_error_message_for(502)
      @errors << error_message

      http_code
    elsif etablissement_not_found?
      set_error_message_for(404)
    else
      @raw_response.code.to_i
    end
  end

  private

  def http_internal_error?
    @raw_response.code == '500'
  end

  def custom_internal_error?
    raw_response_code == '4'
  end

  def etablissement_not_found?
    raw_response_code == "8"
  end

  def error_message
    ProviderInternalServerError.new(
      provider_name,
      "Erreur fournisseur: #{entete[:message]}",
    )
  end

  def raw_response_code
    entete[:code]
  end

  def invalid_json?
    entete

    false
  rescue JSON::ParserError => e
    add_context_to_provider_error_tracking(
      {
        exception_message: e.message,
        body:              @body,
      }
    )

    true
  end

  def entete
    @entete ||= JSON.parse(@body, symbolize_names: true)[:entete]
  end
end
