module SecurityEvent::Tracking
  extend ActiveSupport::Concern

  SETTINGS_KEYS = %i[
    security_event_name
    security_event_target_type
    security_event_target_id
    security_event_computed_details
    security_event_condition
  ].freeze

  class_methods do
    attr_reader :security_event_name

    def tracks_security_event(name, target_id:, **options)
      options.assert_valid_keys(:computed_details, :only_if)
      @security_event_name = name
      @security_event_settings = {
        security_event_name: name,
        security_event_target_id: target_id,
        security_event_computed_details: options[:computed_details],
        security_event_condition: options[:only_if]
      }

      around :scope_security_event_settings
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
end
