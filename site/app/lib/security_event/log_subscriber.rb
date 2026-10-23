class SecurityEvent::LogSubscriber
  LOGSTASH_TYPE = 'admin'.freeze
  REQUEST_LINE_OPEN_KEY = :security_events_request_line_open

  def self.open_request_line
    LogStasher.store.delete(:security_events)
    RequestStore.store[REQUEST_LINE_OPEN_KEY] = true
  end

  def self.close_request_line
    RequestStore.store[REQUEST_LINE_OPEN_KEY] = false
  end

  def emit(event)
    if RequestStore.store[REQUEST_LINE_OPEN_KEY]
      append_to_request_line(event[:payload])
    else
      write_dedicated_line(event[:payload])
    end
  end

  private

  def append_to_request_line(payload)
    LogStasher.store[:security_events] = [*LogStasher.store.fetch(:security_events, []), payload]
  end

  def write_dedicated_line(payload)
    line = LogStasher.build_logstash_event({ type: LOGSTASH_TYPE, security_events: [payload] }, ['security_event'])

    LogStasher.logger&.<<("#{line.to_json}\n")
  end
end
