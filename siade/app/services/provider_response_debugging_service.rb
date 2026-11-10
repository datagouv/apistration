class ProviderResponseDebuggingService
  HEADER_NAME = 'X-Debug-Provider-Response'.freeze

  def initialize(user, request)
    @user = user
    @request = request
  end

  def enable?
    asked_by_header? && ip_restricted_back_office_token?
  end

  private

  attr_reader :user, :request

  def asked_by_header?
    request.headers[HEADER_NAME].present?
  end

  def ip_restricted_back_office_token?
    user.present? &&
      user.back_office? &&
      user.ip_restricted?
  end
end
