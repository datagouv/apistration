# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: bbd1e5a224301367f0fb64b119ec11cb4398c172).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'

module ApiParticulier::Commons
  module Middleware
    class RateLimitParser < Faraday::Middleware
      ENV_KEY = :api_gouv_rate_limit

      def on_complete(env)
        env[ENV_KEY] = ApiParticulier::Commons::RateLimit.from_headers(env.response_headers)
      end
    end
  end
end
