class DatapassWebhook::Receive < ApplicationOrganizer
  include SecurityEvent::Tracking

  MAX_VALUE_LENGTH = 64

  tracks_security_event 'integration.datapass_webhook.received',
    target: :authorization_request,
    actor: ->(context) { SecurityEvent::DATAPASS_ACTOR unless context.failure? },
    computed_details: ->(context) { reception_details(context) }

  tracks_security_event_failures

  organize DatapassWebhook::VerifySignature,
    SecurityEvent::Track

  def self.reception_details(context)
    {
      webhook_event: bounded(context.webhook_event),
      fired_at: firing_time(context.fired_at),
      datapass_id: bounded(context.datapass_id)
    }
  end

  def self.bounded(value)
    value.to_s.first(MAX_VALUE_LENGTH).presence
  end

  def self.firing_time(value)
    seconds = Integer(value.to_s, exception: false)

    Time.zone.at(seconds) if seconds
  end
end
