class PoleEmploi::Indemnites::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found? || http_code == 204

    unknown_provider_response! if !http_ok? || invalid_json? || json_body['statutInscription'].blank?
  end
end
