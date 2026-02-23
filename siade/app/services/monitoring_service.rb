require 'singleton'
require 'forwardable'
require 'sentry-ruby'

class MonitoringService
  include Singleton
  extend Forwardable

  RESPONSE_BODY_KEYS = %i[http_response_body body].freeze

  PERSONAL_DATA_JSON_KEYS = %w[
    nom prenom prenoms nomNaissance nomUsage
    email telephone dateNaissance adresse civilite sexe
  ].freeze

  PERSONAL_DATA_THRESHOLD = 2

  def_delegators :Sentry,
    :capture_message,
    :set_user,
    :set_tags

  def set_context(title, context)
    Sentry.set_context(title, sanitize_personal_data(context))
  end

  def track_provider_error(error)
    extra_context = error.to_h.merge(error.monitoring_private_context)

    set_context('Provider error', extra_context)

    track(
      error.tracking_level,
      "[#{current_provider}] Error: #{error.detail}",
      fingerprint: ['provider-error', error.code]
    )
  end

  def track_with_added_context(level, message, extra_context)
    set_context('Extra context', extra_context)

    track(level, message)
  end

  def track_deprecated_data(field, deprecated_data)
    track(
      'info',
      "[#{current_provider}] Deprecated data for field '#{field}'. Value: #{deprecated_data}"
    )
  end

  def set_user_context(context)
    set_user(context)
  end

  def set_controller_params(params)
    params.stringify_keys!

    set_context('Controller params', params: params.except('token'))

    set_tags(
      endpoint: "#{params['controller']}##{params['action']}"
    )
  end

  def set_provider(provider_name)
    set_tags(provider: provider_name)
  end

  def set_retriever_context(context)
    set_context('Retriever', context.to_h)
  end

  def track(level, message, fingerprint: nil)
    options = { level: }
    options[:fingerprint] = fingerprint if fingerprint
    capture_message(message, **options)

    Rails.logger.public_send(extract_logger_level(level), message)
  end

  private

  def sanitize_personal_data(context)
    body_key = RESPONSE_BODY_KEYS.find { |k| context[k].present? }
    return context unless body_key
    return context unless contains_personal_data?(context[body_key])

    context.merge(body_key => encrypt_body(context[body_key]))
  end

  def contains_personal_data?(body)
    PERSONAL_DATA_JSON_KEYS.count { |key| body.match?(/"#{key}"\s*:/i) } >= PERSONAL_DATA_THRESHOLD
  end

  def encrypt_body(body)
    DataEncryptor.new(body).encrypt.to_s
  rescue GPGME::Error => e
    track(:error, "Failed to encrypt personal data in response body: #{e.message}")
    '[personal data detected but encryption failed]'
  end

  def set_extra_context(title, context)
    with_scope do |scope|
      scope.set_context(title, context)
      yield if block_given?
    end
  end

  def extract_logger_level(level)
    if level == 'warning'
      'warn'
    else
      level
    end
  end

  def current_provider
    Sentry.get_current_scope.tags[:provider]
  end

  def humanized_response_for_tracking(response)
    "#{response.class.name.demodulize} (provider error code: #{response.provider_error_custom_code})"
  end
end
