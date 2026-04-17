# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 7fba210b2ead8fd60ba2fa3ebe31d341c1229cc4).
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

Faraday::Response.register_middleware(api_gouv_rate_limit: ApiEntreprise::Commons::Middleware::RateLimitParser)
