class SIADE::V2::Responses::INPI::GetDocuments < SIADE::V2::Responses::Generic
  protected

  def provider_name
    'INPI'
  end

  def adapt_raw_response_code
    code = raw_response.code.to_i
    if code == 500
      set_error_message_for(502)
    else
      code
    end
  end

  private

  def set_error_message_502
    @errors ||= []
    @errors.concat(build_errors_from_payload)
  end

  def build_errors_from_payload
    JSON.parse(raw_response.body)['globalErrors'].map do |error_message|
      ProviderUnknownError.new(provider_name, "Erreur retournée par l'INPI: #{error_message}")
    end
  end
end
