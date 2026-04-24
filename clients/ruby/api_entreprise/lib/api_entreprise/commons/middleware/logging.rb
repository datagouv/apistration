# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 3f647e0d78209049ba64ba642be269590d3af52a).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'

module ApiEntreprise::Commons
  module Middleware
    class Logging < Faraday::Middleware
      def initialize(app, logger: nil, redact_query: false)
        super(app)
        @logger = logger
        @redact_query = redact_query
      end

      def call(env)
        started = monotonic_now
        response = @app.call(env)
        log(env, response, monotonic_now - started) if @logger
        response
      rescue StandardError => e
        log_error(env, e, monotonic_now - started) if @logger
        raise
      end

      private

      def log(env, response, duration_ms)
        @logger.info(
          method: env.method.to_s.upcase,
          url: safe_url(env.url),
          status: response.status,
          duration_ms: duration_ms.round(1),
          rate_limit_remaining: extract_remaining(response.env.response_headers)
        )
      end

      def log_error(env, exception, duration_ms)
        @logger.error(
          method: env.method.to_s.upcase,
          url: safe_url(env.url),
          error: exception.class.name,
          message: exception.message,
          duration_ms: duration_ms.round(1)
        )
      end

      def safe_url(url)
        return url.to_s unless @redact_query

        dup = url.dup
        dup.query = nil
        "#{dup}?[REDACTED]"
      end

      def extract_remaining(headers)
        return nil unless headers

        headers.each do |k, v|
          return v.to_i if k.to_s.downcase == 'ratelimit-remaining' && !v.nil? && !v.to_s.empty?
        end
        nil
      end

      def monotonic_now
        Process.clock_gettime(Process::CLOCK_MONOTONIC) * 1000.0
      end
    end
  end
end
