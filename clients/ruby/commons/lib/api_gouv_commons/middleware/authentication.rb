require 'faraday'

module ApiGouvCommons
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
          raise ApiGouvCommons::AuthenticationError.new(
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
