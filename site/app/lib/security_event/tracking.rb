module SecurityEvent::Tracking
  extend ActiveSupport::Concern

  UNEXPECTED_ERROR_REASON = 'unexpected_error'.freeze
  ADMIN_ACTOR = ->(context) { SecurityEvent.actor_for(context.admin) if context.admin }
  SETTINGS_KEYS = %i[
    security_event_name
    security_event_target_key
    security_event_actor
    security_event_details
    security_event_detail_keys
    security_event_computed_details
    security_event_condition
    security_event_denial_reason
  ].freeze

  class_methods do
    attr_reader :security_event_name

    def tracks_security_event(name, target:, **options)
      options.assert_valid_keys(:actor, :details, :details_from_context, :computed_details, :only_if)
      @security_event_name = name
      @security_event_settings = {
        security_event_name: name,
        security_event_target_key: target,
        security_event_actor: options[:actor],
        security_event_details: options.fetch(:details, {}),
        security_event_detail_keys: options.fetch(:details_from_context, []),
        security_event_computed_details: options[:computed_details],
        security_event_condition: options[:only_if],
        security_event_denial_reason: nil
      }

      around :scope_security_event_settings
    end

    def tracks_security_event_failures
      around :track_security_event_failure
    end

    def security_event_settings
      @security_event_settings
    end
  end

  private

  def scope_security_event_settings(interactor)
    enclosing_settings = context.to_h.slice(*SETTINGS_KEYS)
    self.class.security_event_settings.each { |key, value| context[key] = value }

    interactor.call
  ensure
    SETTINGS_KEYS.each { |key| context[key] = enclosing_settings[key] }
  end

  def track_security_event_failure(interactor)
    interactor.call
  rescue Interactor::Failure
    SecurityEvent::Track.call(context)
    raise
  rescue StandardError
    context.security_event_denial_reason = UNEXPECTED_ERROR_REASON
    SecurityEvent::Track.call(context)
    raise
  end
end
