class DataSubvention::Subventions::ValidateResponse < ValidateResponse
  def call
    resource_not_found! if http_not_found?
    unknown_provider_response! if !http_ok? || invalid_json?
    resource_not_found! if empty_subventions?
  end

  private

  def empty_subventions?
    json_body['subventions'].empty?
  end
end
