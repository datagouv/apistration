class INPI::RNE::Download::ValidateResponse < ValidateResponse
  def call
    return if http_ok?

    resource_not_found! if http_not_found?
    handle_forbidden! if http_forbidden?
    rate_limited! if http_too_many_requests?

    unknown_provider_response!
  end

  private

  def handle_forbidden!
    MonitoringService.instance.track_with_added_context(
      'warning',
      'INPI RNE Download: Cloudflare 403',
      { document_id: context.params[:document_id] }
    )

    provider_unavailable!
  end
end
