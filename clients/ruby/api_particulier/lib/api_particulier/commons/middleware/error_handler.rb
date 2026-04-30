# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'
require 'json'

module ApiParticulier::Commons
  module Middleware
    class ErrorHandler < Faraday::Middleware
      AUTH_CODES = %w[00101 00103 00105].freeze
      AUTHORIZATION_CODES = %w[00100].freeze

      def on_complete(env)
        status = env.status
        return if status.between?(200, 299)

        exception = map_exception(status, env)
        raise exception if exception
      end

      def call(env)
        super
      rescue Faraday::TimeoutError, Faraday::ConnectionFailed => e
        raise ApiParticulier::Commons::TransportError.new(
          e.message,
          method: env.method,
          url: env.url.to_s
        )
      end

      private

      def map_exception(status, env)
        errors = extract_errors(env.body)
        klass = klass_for(status)
        return nil unless klass

        kwargs = {
          http_status: status,
          errors: errors,
          method: env.method,
          url: env.url.to_s
        }

        if klass == ApiParticulier::Commons::RateLimitError
          kwargs[:retry_after] = compute_retry_after(env, errors)
        elsif klass == ApiParticulier::Commons::ProviderError
          kwargs[:retry_after] = provider_retry(errors)
        end

        klass.new(nil, **kwargs)
      end

      def klass_for(status)
        case status
        when 401 then ApiParticulier::Commons::AuthenticationError
        when 403 then ApiParticulier::Commons::AuthorizationError
        when 404 then ApiParticulier::Commons::NotFoundError
        when 409 then ApiParticulier::Commons::ConflictError
        when 422 then ApiParticulier::Commons::ValidationError
        when 429 then ApiParticulier::Commons::RateLimitError
        when 400..499 then ApiParticulier::Commons::ClientError
        when 502 then ApiParticulier::Commons::ProviderError
        when 503, 504 then ApiParticulier::Commons::ProviderUnavailableError
        when 500..599 then ApiParticulier::Commons::ServerError
        end
      end

      def extract_errors(body)
        parsed = body
        parsed = safely_parse(body) if body.is_a?(String)
        return [] unless parsed.is_a?(Hash)

        Array(parsed['errors'] || parsed[:errors])
      end

      def safely_parse(body)
        JSON.parse(body)
      rescue JSON::ParserError
        nil
      end

      def compute_retry_after(env, errors)
        from_headers = ApiParticulier::Commons::RateLimit.from_headers(env.response_headers)&.retry_after
        return from_headers if from_headers && from_headers.positive?

        provider_retry(errors) || from_headers
      end

      def provider_retry(errors)
        first = errors.first || {}
        meta = first['meta'] || first[:meta] || {}
        value = meta['retry_in'] || meta[:retry_in]
        return nil if value.nil?

        Integer(value)
      rescue ArgumentError, TypeError
        nil
      end
    end
  end
end
# No Faraday.register_middleware: symbols are process-global and collide when
# multiple gouv.fr gems are loaded in the same process. Clients pass the class
# directly to conn.response / conn.use.
