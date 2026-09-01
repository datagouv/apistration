module CanExposeProviderResponse
  extend ActiveSupport::Concern

  included do
    after_action :expose_provider_response!, if: :expose_provider_response?
  end

  private

  def expose_provider_response?
    ProviderResponseDebuggingService.new(current_user, request).enable? &&
      json_response? &&
      provider_raw_response.present?
  end

  def expose_provider_response!
    payload = JSON.parse(response.body)
    payload['meta'] = (payload['meta'] || {}).merge(
      'provider_response' => ProviderRawResponse.new(provider_raw_response).as_meta
    )

    response.body = payload.to_json
  rescue JSON::ParserError, TypeError, NoMethodError
    nil
  end

  def provider_raw_response
    @organizer&.context&.response
  end

  def json_response?
    response.media_type.to_s.include?('json')
  end
end
