class ApplicationJob < ActiveJob::Base
  retry_on StandardError, wait: :polynomially_longer, attempts: 5

  def self.without_retry(*errors)
    rescue_from(*errors.presence || StandardError) { |error| raise error }
  end

  private

  def frontal_production?
    Rails.env.production? &&
      ENV['FRONTAL'] == 'true'
  end
end
