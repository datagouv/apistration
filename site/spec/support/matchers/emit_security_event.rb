class SecurityEventRecorder
  attr_reader :events

  def initialize
    @events = []
  end

  def emit(event)
    events << event[:payload]
  end

  def record
    Rails.event.subscribe(self) { |event| event[:name] == SecurityEvent::NOTIFICATION_NAME }
    yield
    events
  ensure
    Rails.event.unsubscribe(self)
  end
end

RSpec::Matchers.define :emit_security_event do |expected_name|
  supports_block_expectations

  chain(:with) { |expected_attributes| @expected_attributes = expected_attributes }

  match do |block|
    @expected_event = hash_including(event: expected_name, **(@expected_attributes || {}))
    @emitted_events = SecurityEventRecorder.new.record(&block)
    @emitted_events.any? { |event| values_match?(@expected_event, event) }
  end

  match_when_negated do |block|
    @emitted_events = SecurityEventRecorder.new.record(&block)
    @emitted_events.none? { |event| event[:event] == expected_name }
  end

  failure_message do
    "expected security event #{@expected_event.description}, emitted: #{@emitted_events.inspect}"
  end

  failure_message_when_negated do
    "expected no #{expected_name} security event, emitted: #{@emitted_events.inspect}"
  end
end
