class MSA::ConformitesCotisations::ValidateResponse < ValidateResponse
  class InvalidStatus < StandardError; end

  def call
    if !http_ok?
      unknown_provider_response!
    elsif status == :unknown
      resource_not_found!(:siret)
    end
  rescue InvalidStatus
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
end
