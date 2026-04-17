# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 7fba210b2ead8fd60ba2fa3ebe31d341c1229cc4).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'

module ApiParticulier::Commons
  module Middleware
    class Authentication < Faraday::Middleware
      def initialize(app, auth_strategy:)
        super(app)
        @auth_strategy = auth_strategy
      end

      def on_request(env)
        return if @auth_strategy.nil?

        request = RequestWrapper.new(env)
        begin
          @auth_strategy.apply(request)
        rescue StandardError => e
          raise ApiParticulier::Commons::AuthenticationError.new(
            "auth strategy raised: #{e.message}",
            method: env.method,
            url: env.url.to_s
          )
        end
      end

      class RequestWrapper
        def initialize(env)
          @env = env
        end

        def headers
          @env.request_headers
        end

        def method
          @env.method
        end

        def url
          @env.url
        end
      end
    end
  end
end

Faraday::Request.register_middleware(api_gouv_authentication: ApiParticulier::Commons::Middleware::Authentication)
