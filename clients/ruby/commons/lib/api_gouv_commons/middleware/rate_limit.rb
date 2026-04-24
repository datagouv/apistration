require 'faraday'

module ApiGouvCommons
  module Middleware
    class RateLimitParser < Faraday::Middleware
      ENV_KEY = :api_gouv_rate_limit

      def on_complete(env)
        env[ENV_KEY] = ApiGouvCommons::RateLimit.from_headers(env.response_headers)
      end
    end
  end
end
