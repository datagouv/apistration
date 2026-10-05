class INSEE::GrantRefusal
  REASONS = {
    /temporarily disabled/i => 'account_temporarily_disabled',
    /disabled/i => 'account_disabled',
    /not fully set up/i => 'account_not_fully_set_up',
    /invalid user credentials/i => 'refused_login'
  }.freeze

  def initialize(response, payload)
    @http_response_code = response.code.to_i
    @provider_error = payload['error']
    @provider_error_description = payload['error_description']
  end

  def to_h
    {
      http_response_code: @http_response_code,
      provider_error: @provider_error,
      provider_error_description: @provider_error_description,
      refusal_reason: reason
    }.compact_blank
  end

  private

  def reason
    return if @provider_error_description.blank?

    REASONS.find { |pattern, _reason| pattern.match?(@provider_error_description) }&.last || 'unknown'
  end
end
