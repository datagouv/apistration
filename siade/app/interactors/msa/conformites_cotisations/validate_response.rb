class MSA::ConformitesCotisations::ValidateResponse < ValidateResponse
  class InvalidStatus < StandardError; end

  def call
    resource_not_found!(:siret) if http_ok? && status == :unknown

    return if http_ok?

    internal_server_error! if bad_gateway_in_response? || timeout_in_response?

    unknown_provider_response!
  rescue InvalidStatus, JSON::ParserError
    unknown_provider_response!
  end

  private

  def status
    case json_body['TopRMPResponse']['topRegMarchePublic']
    when 'O'
      :up_to_date
    when 'N'
      :outdated
    when 'A'
      :under_investigation
    when 'S'
      :unknown
    else
      raise InvalidStatus
    end
  end

  def bad_gateway_in_response?
    json_body['Erreur'] && json_body['Erreur']['Message'] == '502 Bad Gateway'
  end

  def timeout_in_response?
    json_body['Erreur'] && json_body['Erreur']['Message'] == '504 Gateway Timeout'
  end
end
