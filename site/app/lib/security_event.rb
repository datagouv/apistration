module SecurityEvent
  NOTIFICATION_NAME = 'security_event'.freeze
  CATALOG_PATH = Rails.root.join('config/security_events.yml')
  ANONYMOUS_ACTOR = { email: nil, role: 'anonymous' }.freeze

  class UndeclaredError < StandardError; end

  class << self
    def emit(name, target:, details: {}, actor: request_actor)
      payload = build_payload(name.to_s, target, details.compact, actor)

      ActiveRecord.after_all_transactions_commit do
        Rails.event.notify(NOTIFICATION_NAME, payload)
      end
    end

    def set_request_context(user:, true_user:)
      Rails.event.set_context(
        security_event_actor: actor_for(user),
        security_event_impersonated_by: impersonator_email(user, true_user)
      )
    end

    def actor_for(user)
      return ANONYMOUS_ACTOR.dup if user.nil?

      { email: user.email, role: role_for(user) }
    end

    def catalog
      @catalog ||= YAML.load_file(CATALOG_PATH)
    end

    private

    def build_payload(name, target, details, actor)
      details = details.merge(impersonated_by: Rails.event.context[:security_event_impersonated_by]).compact
      details = details.merge(catalog_error: report_catalog_error(name, details)).compact

      {
        event: name,
        actor:,
        target:,
        details: details.presence
      }.compact
    end

    def report_catalog_error(name, details)
      error = catalog_error(name, details)
      return if error.nil?

      Rails.error.unexpected(UndeclaredError.new(error))
      error
    end

    def catalog_error(name, details)
      declaration = catalog['events'][name]
      return "#{name} is not declared in the security events catalog" if declaration.nil?

      undeclared_details = details.keys.map(&:to_s) - declaration.fetch('details', []) - catalog['common_details']
      "#{name} details are not declared: #{undeclared_details.join(', ')}" if undeclared_details.any?
    end

    def request_actor
      Rails.event.context[:security_event_actor] || ANONYMOUS_ACTOR.dup
    end

    def role_for(user)
      if user.admin?
        'admin'
      elsif user.editor?
        'editor'
      else
        'user'
      end
    end

    def impersonator_email(user, true_user)
      true_user.email if true_user.present? && true_user != user
    end
  end
end
