class SIADE::V2::Responses::TimeoutError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::ProviderTimeoutError.new(provider_name)
  end

  def http_code
    504
  end
end
