class ProviderResponseDebuggingService
  HEADER_NAME = 'X-Debug-Provider-Response'.freeze
  CREDENTIALS_KEY = :debug_provider_response_token_ids

  def initialize(user, request)
    @user = user
    @request = request
  end

  def enable?
    asked_by_header? && whitelisted_token?
  end

  private

  attr_reader :user, :request

  def asked_by_header?
    request.headers[HEADER_NAME].present?
  end

  def whitelisted_token?
    user.present? &&
      whitelisted_token_ids.include?(user.token_id)
  end

  def whitelisted_token_ids
    Array(Siade.credentials.fetch(CREDENTIALS_KEY, [])).map(&:to_s)
  end
end
