class FabriqueNumeriqueMinisteresSociaux::ConventionsCollectives::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if !http_ok? || invalid_json?
    resource_not_found! if json_body[0]['conventions'].blank?
  end
end
