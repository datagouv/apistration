class SIADE::V2::Responses::UnexpectedError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::ProviderUnknownError.new(provider_name)
  end

  def http_code
    502
  end
end
