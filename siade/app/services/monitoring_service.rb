require 'singleton'
require 'forwardable'
require 'sentry-ruby'

class MonitoringService
  include Singleton
  extend Forwardable

  def_delegators :Sentry,
    :capture_message,
    :with_scope,
    :set_user,
    :set_tags

  def track_provider_error(error)
    extra_context = error.to_h.merge(error.monitoring_private_context)

    set_extra_context('Provider error', extra_context) do
      track(
        error.tracking_level,
        "[#{current_provider}] Error: #{error.detail}"
      )
    end
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

    set_extra_context('Controller params', params: params.except('token'))

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
    set_extra_context('Retriever', context.to_h)
  end

  def track(level, message, extra_context = {})
    set_extra_context('Extra context', extra_context) if extra_context.present?

    capture_message(message, level:)

    Rails.logger.public_send(extract_logger_level(level), message)
  end

  private

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
