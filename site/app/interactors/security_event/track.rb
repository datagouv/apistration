class SecurityEvent::Track < ApplicationInteractor
  def call
    SecurityEvent.emit(context.security_event_name, target:, details:, **actor)
  end

  private

  def target
    {
      type: SecurityEvent.catalog.dig('events', context.security_event_name, 'target_type'),
      id: context.public_send(context.security_event_target_key)&.id
    }
  end

  def details
    details = context.security_event_details.merge(context.to_h.slice(*context.security_event_detail_keys))
    return details if denial_reason.nil?

    details.merge(reason: denial_reason, outcome: 'denied')
  end

  def denial_reason
    context.failure? ? context.message : context.security_event_denial_reason
  end

  def actor
    return {} if context.security_event_actor.nil?

    { actor: context.security_event_actor.call(context) }
  end
end
