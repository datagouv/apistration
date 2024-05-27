class INPI::RNE::ActesBilans::ValidateResponse < ValidateResponse
  # rubocop:disable Metrics/CyclomaticComplexity
  def call
    resource_not_found! if (http_ok? && json_body.empty?) || http_not_found?

    return if http_ok? && actes_present?

    provider_internal_error! if http_internal_error?

    provider_unavailable! if http_too_many_requests?

    unknown_provider_response!
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def actes_present?
    json_body['actes'].present?
  end
end
