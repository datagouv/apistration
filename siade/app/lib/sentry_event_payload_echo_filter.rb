class SentryEventPayloadEchoFilter
  PAYLOAD_ECHOING_EXCEPTIONS = %w[JSON::ParserError].freeze

  REMOVED_MESSAGE = 'message removed: it may quote the parsed payload, see the Parse error context'.freeze

  def self.call(event)
    echoing_exceptions(event).each_with_index do |exception, index|
      event.contexts = event.contexts.merge("Parse error #{index + 1}" => { encrypted_message: encrypt(exception.value) })
      exception.value = REMOVED_MESSAGE
    end
  end

  def self.echoing_exceptions(event)
    Array(event.try(:exception)&.values).select { |exception| PAYLOAD_ECHOING_EXCEPTIONS.include?(exception.type) }
  end

  def self.encrypt(message)
    MonitoringService.instance.encrypt_for_tracking(message.to_s)
  end

  private_class_method :echoing_exceptions, :encrypt
end
