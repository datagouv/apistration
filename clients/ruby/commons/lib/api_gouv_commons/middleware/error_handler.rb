require 'faraday'
require 'json'

module ApiGouvCommons
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
        raise ApiGouvCommons::TransportError.new(
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

        if klass == ApiGouvCommons::RateLimitError
          kwargs[:retry_after] = compute_retry_after(env, errors)
        elsif klass == ApiGouvCommons::ProviderError
          kwargs[:retry_after] = provider_retry(errors)
        end

        klass.new(nil, **kwargs)
      end

      def klass_for(status)
        case status
        when 401 then ApiGouvCommons::AuthenticationError
        when 403 then ApiGouvCommons::AuthorizationError
        when 404 then ApiGouvCommons::NotFoundError
        when 409 then ApiGouvCommons::ConflictError
        when 422 then ApiGouvCommons::ValidationError
        when 429 then ApiGouvCommons::RateLimitError
        when 400..499 then ApiGouvCommons::ClientError
        when 502 then ApiGouvCommons::ProviderError
        when 503 then ApiGouvCommons::ProviderUnavailableError
        when 500..599 then ApiGouvCommons::ServerError
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
        from_headers = ApiGouvCommons::RateLimit.from_headers(env.response_headers)&.retry_after
        return from_headers if from_headers && from_headers.positive?

        provider_retry(errors) || from_headers || 0
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

Faraday::Response.register_middleware(api_gouv_error_handler: ApiGouvCommons::Middleware::ErrorHandler)
