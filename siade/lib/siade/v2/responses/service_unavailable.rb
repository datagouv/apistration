class SIADE::V2::Responses::ServiceUnavailable < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ProviderUnavailable.new(provider_name)
  end

  def http_code
    502
  end
end
