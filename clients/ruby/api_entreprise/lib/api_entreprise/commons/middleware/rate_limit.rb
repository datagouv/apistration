# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 35aaaaedcd3b760511d070e4e4c101ca3c5cdb32).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'

module ApiEntreprise::Commons
  module Middleware
    class RateLimitParser < Faraday::Middleware
      ENV_KEY = :api_gouv_rate_limit

      def on_complete(env)
        env[ENV_KEY] = ApiEntreprise::Commons::RateLimit.from_headers(env.response_headers)
      end
    end
  end
end
