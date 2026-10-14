module SecurityEvent::Tracking
  extend ActiveSupport::Concern

  class_methods do
    attr_reader :security_event_name

    def tracks_security_event(name, target:, actor: nil, details: {}, details_from_context: [], failures: false)
      @security_event_name = name

      before do
        context.security_event_name = name
        context.security_event_target_key = target
        context.security_event_actor = actor
        context.security_event_details = details
        context.security_event_detail_keys = details_from_context
      end

      around :track_security_event_failure if failures
    end
  end

  private

  def track_security_event_failure(interactor)
    interactor.call
  ensure
    SecurityEvent::Track.call(context) if context.failure?
  end
end
