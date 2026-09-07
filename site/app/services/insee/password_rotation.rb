class INSEE::PasswordRotation
  class UnavailableError < StandardError; end
  class BypassNotInUseError < StandardError; end
  class DerivationNotStartedError < StandardError; end

  DESYNCHRONIZED_MESSAGE = 'INSEE password desynchronized: neither the expected nor the fallback password authenticates'.freeze

  def initialize(authentication: INSEEAPIAuthentication.new, renewal: INSEEPasswordRenewal.new)
    @authentication = authentication
    @renewal = renewal
  end

  def held_back?
    @authentication.recently_failed?
  end

  def rotate!
    converge_on_current_password(from: INSEE::PasswordDerivation.previous_password)
  end

  def exit_bypass!
    raise BypassNotInUseError, 'no bypass credential is configured' unless INSEE::PasswordDerivation.bypassed?
    raise DerivationNotStartedError, "derivation opens on #{INSEE::PasswordDerivation::DERIVATION_START}" if before_derivation_window?

    converge_on_current_password(from: INSEE::PasswordDerivation.bypass_password)
  end

  private

  def converge_on_current_password(from:)
    return :already_current if probe(current_password).status == :granted

    fallback = probe(from)

    return renew(old_password: from, token: fallback.token) if fallback.status == :granted

    @authentication.record_authentication_failure!(DESYNCHRONIZED_MESSAGE)

    :desynchronized
  end

  def probe(password)
    attempt = @authentication.attempt(password)

    fail_on_refusal! if attempt.status == :rejected
    raise UnavailableError, 'INSEE OAuth is unavailable' if attempt.status == :unavailable

    attempt
  end

  def fail_on_refusal!
    @authentication.record_authentication_failure!(INSEEAPIAuthentication::REFUSED_EXCHANGE_MESSAGE)

    raise UnavailableError, INSEEAPIAuthentication::REFUSED_EXCHANGE_MESSAGE
  end

  def renew(old_password:, token:)
    response = @renewal.renew(token:, old_password:, new_password: current_password)

    return :renewed if response.status == 200

    raise UnavailableError, "INSEE rejected the renewal (HTTP #{response.status}): #{response.body}"
  rescue Faraday::Error => e
    raise UnavailableError, "INSEE password renewal did not reach INSEE: #{e.message}"
  end

  def before_derivation_window?
    INSEE::PasswordDerivation.current_period < INSEE::PasswordDerivation::DERIVATION_START
  end

  def current_password
    @current_password ||= INSEE::PasswordDerivation.current_password
  end
end
