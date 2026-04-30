# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
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
