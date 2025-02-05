class DGFIP::ValidateResponse < ValidateResponse
  def runtime_error?
    http_internal_error? &&
      valid_json? &&
      json_body.dig('erreur', 'code')
  end
end
