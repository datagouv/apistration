# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: bbd1e5a224301367f0fb64b119ec11cb4398c172).
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
