class INSEE::ValidateResponse < ValidateResponse
  def call
    if http_ok? && valid_json?
      validate_ok_response
    elsif http_not_found?
      resource_not_found!
    elsif http_forbidden?
      handle_forbidden!
    elsif http_internal_error?
      provider_internal_error!
    else
      unknown_provider_response!
    end
  end

  private

  def validate_ok_response; end

  def handle_forbidden!
    unknown_provider_response!
  end
end
