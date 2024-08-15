require 'singleton'
require 'forwardable'
require 'sentry-ruby'

class MonitoringService
  include Singleton
  extend Forwardable

  def_delegators :Sentry,
    :capture_message,
    :set_extras,
    :set_user,
    :set_tags

  def track_provider_error(error)
    set_extras(
      error.to_h.merge(
        error.monitoring_private_context
      )
    )

    track(
      error.tracking_level,
      "[#{current_provider}] Error: #{error.detail}"
    )
  end

  def track_missing_data(field, exception)
    set_extras(
      exception: exception.message,
      backtrace: exception.backtrace
    )

    track(
      'info',
      "[#{current_provider}] Missing following field: #{field}"
    )
  end

  def track_deprecated_data(field, deprecated_data)
    track(
      'info',
      "[#{current_provider}] Deprecated data for field '#{field}'. Value: #{deprecated_data}"
    )
  end

  def set_user_context(context)
    set_user(
      context
    )
  end

  def set_controller_params(params)
    params.stringify_keys!

    set_extras(
      params: params.except('token')
    )
    set_tags(
      endpoint: "#{params['controller']}##{params['action']}"
    )
  end

  def set_provider(provider_name)
    set_tags(
      provider: provider_name
    )
  end

  def set_retriever_context(context)
    set_extras(context.to_h)
  end

  def track(level, message, extra_context = {})
    set_extras(extra_context) if extra_context.present?

    capture_message(message, level:)

    Rails.logger.public_send(extract_logger_level(level), message)
  end

  private

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
