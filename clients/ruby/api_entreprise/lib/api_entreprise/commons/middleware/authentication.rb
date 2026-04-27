# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: a892f7b7177b8df6fa167cfcce18cf92ef23c6b5).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'

module ApiEntreprise::Commons
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
          raise ApiEntreprise::Commons::AuthenticationError.new(
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
