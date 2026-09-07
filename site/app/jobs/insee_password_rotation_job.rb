class INSEEPasswordRotationJob < ApplicationJob
  include GoodJob::ActiveJobExtensions::Concurrency

  CONCURRENCY_KEY = 'insee_password_rotation'.freeze

  good_job_control_concurrency_with(total_limit: 1, key: CONCURRENCY_KEY)

  def perform
    return unless frontal_production?
    return if INSEE::PasswordDerivation.bypassed?
    return if INSEE::PasswordDerivation.current_period < INSEE::PasswordDerivation::DERIVATION_START
    return if rotation.held_back?

    notify(:info, 'INSEE password rotated') if rotation.rotate! == :renewed
  rescue INSEE::PasswordRotation::UnavailableError => e
    notify(:warning, 'INSEE password rotation skipped', { exception_message: e.message })
  end

  private

  def notify(level, message, context = {})
    MonitoringService.instance.track(message, level:, context:)
  end

  def rotation
    @rotation ||= INSEE::PasswordRotation.new
  end
end
