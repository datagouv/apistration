class SecurityEvent::Track < ApplicationInteractor
  def call
    return unless action_happened?

    SecurityEvent.emit(context.security_event_name, target:, actor: SecurityEvent.api_client_actor, details:)
  end

  private

  def action_happened?
    context.security_event_condition.nil? || context.security_event_condition.call(context)
  end

  def target
    {
      type: SecurityEvent.catalog.dig('events', context.security_event_name, 'target_type'),
      id: context.security_event_target_id.call(context)
    }
  end

  def details
    return {} if context.security_event_computed_details.nil?

    context.security_event_computed_details.call(context)
  end
end
