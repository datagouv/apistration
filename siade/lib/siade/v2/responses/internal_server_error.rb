class SIADE::V2::Responses::InternalServerError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::ProviderInternalServerError.new(provider_name)
  end

  def http_code
    502
  end
end
