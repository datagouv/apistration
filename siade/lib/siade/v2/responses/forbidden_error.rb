class SIADE::V2::Responses::ForbiddenError < SIADE::V2::Responses::AbstractProviderError
  def error
    @error ||= ::ForbiddenError.new
  end

  def http_code
    403
  end
end
