class SIADE::V2::Responses::NetworkError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= NetworkError.new
  end

  def http_code
    502
  end
end
