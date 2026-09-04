class INSEEPasswordRotationJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  CONCURRENCY_KEY = 'insee_password_rotation'.freeze

  good_job_control_concurrency_with(total_limit: 1, key: CONCURRENCY_KEY)

  def perform
    return unless frontal_production?
    return if INSEE::PasswordDerivation.bypassed?
    return if INSEE::PasswordDerivation.current_period < INSEE::PasswordDerivation::DERIVATION_START
    return if authentication.recently_failed?

    case authentication.attempt(current_password).status
    when :granted then nil
    when :invalid_grant then rotate_from_previous_password
    else notify(:warning, 'INSEE password rotation skipped: OAuth unavailable')
    end
  end

  private

  def rotate_from_previous_password
    attempt = authentication.attempt(previous_password)

    case attempt.status
    when :granted then renew(attempt.token)
    when :invalid_grant then notify(:error, 'INSEE password desynchronized: neither current nor previous authenticates')
    else notify(:warning, 'INSEE password rotation skipped: OAuth unavailable')
    end
  end

  def renew(token)
    response = INSEEPasswordRenewal.new.renew(
      token:,
      old_password: previous_password,
      new_password: current_password
    )

    return notify(:info, 'INSEE password rotated') if response.status == 200

    notify(
      :error,
      'INSEE password rotation failed',
      {
        http_response_code: response.status,
        http_response_body: response.body
      }
    )
  rescue Faraday::Error => e
    notify(:error, 'INSEE password renewal did not reach INSEE', { exception_message: e.message })
  end

  def notify(level, message, context = {})
    MonitoringService.instance.track(message, level:, context:)
  end

  def authentication
    @authentication ||= INSEEAPIAuthentication.new
  end

  def current_password
    @current_password ||= INSEE::PasswordDerivation.current_password
  end

  def previous_password
    @previous_password ||= INSEE::PasswordDerivation.previous_password
  end
end
