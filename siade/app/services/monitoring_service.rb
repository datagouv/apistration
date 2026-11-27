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

  RETRIEVER_CONTEXT_CLEAR_KEYS = %i[operation_id provider_name recipient cacheable data_source].freeze

  ENCRYPTION_FAILED_PLACEHOLDER = '[personal data not sent: encryption failed]'.freeze

  def_delegators :Sentry,
    :capture_message,
    :set_user,
    :set_tags

  def set_context(title, context)
    Sentry.set_context(title, sanitize_personal_data(context))
  end

  def track_provider_error(error)
    return if error.tracked?

    Sentry.with_scope do
      set_provider(error.provider_name)
      set_context('Provider error', error.to_h.merge(error.monitoring_private_context))

      track(
        error.tracking_level,
        "[#{error.provider_name}] Error: #{error.detail}",
        fingerprint: ['provider-error', error.code]
      )
    end

    error.mark_as_tracked!
  end

  def track_with_added_context(level, message, extra_context, fingerprint: nil)
    set_context('Extra context', extra_context)

    track(level, message, fingerprint:)
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

    set_context('Controller params', params: params_filter.filter(params))

    set_tags(
      endpoint: "#{params['controller']}##{params['action']}"
    )
  end

  def set_provider(provider_name)
    set_tags(provider: provider_name)
  end

  def current_provider
    Sentry.get_current_scope.tags[:provider]
  end

  def set_retriever_context(context)
    set_context('Retriever', retriever_summary(context))
  end

  def set_retriever_crash_context(context)
    set_context(
      'Retriever',
      retriever_summary(context).merge(encrypted_details: encrypt_for_tracking(retriever_details(context)))
    )
  rescue StandardError => e
    set_retriever_context(context)
    track(:error, "Failed to build the Retriever monitoring details (#{e.class.name})")
  end

  def encrypt_for_tracking(data)
    DataEncryptor.new(data).encrypt.to_s
  rescue StandardError => e
    track(:error, "Failed to encrypt personal data for monitoring (#{e.class.name})")
    ENCRYPTION_FAILED_PLACEHOLDER
  end

  def track(level, message, fingerprint: nil)
    options = { level: }
    options[:fingerprint] = fingerprint if fingerprint
    capture_message(message, **options)

    Rails.logger.public_send(extract_logger_level(level), message)
  end

  private

  def params_filter
    @params_filter ||= ActiveSupport::ParameterFilter.new(Rails.application.config.filter_parameters)
  end

  def retriever_summary(context)
    context.to_h.slice(*RETRIEVER_CONTEXT_CLEAR_KEYS).merge(
      http_response_code: context.response.try(:code),
      error_codes: retriever_error_codes(context)
    ).compact
  end

  def retriever_error_codes(context)
    Array(context.errors).map(&:code)
  rescue StandardError
    nil
  end

  def retriever_details(context)
    {
      params: context.params,
      http_response_body: readable_body(context.response.try(:body))
    }.to_json
  end

  def sanitize_personal_data(context)
    body_key = RESPONSE_BODY_KEYS.find { |k| readable_body(context[k]).present? }
    return context unless body_key
    return context unless contains_personal_data?(readable_body(context[body_key]))

    context.merge(body_key => encrypt_for_tracking(context[body_key]))
  end

  def readable_body(body)
    body.to_s.scrub
  end

  def contains_personal_data?(body)
    PERSONAL_DATA_JSON_KEYS.count { |key| body.match?(/"#{key}"\s*:/i) } >= PERSONAL_DATA_THRESHOLD
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

  def humanized_response_for_tracking(response)
    "#{response.class.name.demodulize} (provider error code: #{response.provider_error_custom_code})"
  end
end
