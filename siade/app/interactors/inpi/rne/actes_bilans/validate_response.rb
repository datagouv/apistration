class INPI::RNE::ActesBilans::ValidateResponse < ValidateResponse
  # rubocop:disable Metrics/CyclomaticComplexity
  def call
    resource_not_found! if (http_ok? && json_body.empty?) || http_not_found?

    return if http_ok? && actes_or_bilans_present?

    provider_internal_error! if http_internal_error?

    handle_http_too_many_requests! if http_too_many_requests?

    unknown_provider_response!
  end
  # rubocop:enable Metrics/CyclomaticComplexity

  private

  def handle_http_too_many_requests!
    fail_with_error!(build_error(ProviderRateLimitingError))
  end

  def actes_or_bilans_present?
    json_body['actes'].present? ||
      json_body['bilans'].present?
  end
end
