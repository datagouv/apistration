module SecurityEvent
  NOTIFICATION_NAME = 'security_event'.freeze
  CATALOG_PATH = Rails.root.join('config/security_events.yml')
  SERVICE = 'siade'.freeze

  class UndeclaredError < StandardError; end

  class << self
    def emit(name, target:, actor:, details: {})
      details = details.compact
      details = details.merge(catalog_error: report_catalog_error(name.to_s, details)).compact

      Rails.event.notify(NOTIFICATION_NAME, { event: name.to_s, actor:, target:, details: details.presence }.compact)
    end

    def api_client_actor
      { email: nil, role: 'api_client' }
    end

    def catalog
      @catalog ||= YAML.load_file(CATALOG_PATH)
    end

    private

    def report_catalog_error(name, details)
      error = catalog_error(name, details)
      return if error.nil?

      Rails.error.unexpected(UndeclaredError.new(error))
      error
    end

    def catalog_error(name, details)
      declaration = catalog['events'][name]
      return "#{name} is not declared in the security events catalog" if declaration.nil?
      return "#{name} is not declared for #{SERVICE}" if declaration['services'].exclude?(SERVICE)

      undeclared_details = details.keys.map(&:to_s) - declaration.fetch('details', []) - catalog['common_details']
      "#{name} details are not declared: #{undeclared_details.join(', ')}" if undeclared_details.any?
    end
  end
end
