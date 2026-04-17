require 'faraday'
require 'json'

module ApiGouvCommons
  module Middleware
    class Envelope < Faraday::Middleware
      def on_complete(env)
        body = env.body
        return if body.nil? || body.is_a?(Hash) || body.is_a?(Array)
        return unless body.is_a?(String) && !body.empty?

        parsed =
          begin
            JSON.parse(body)
          rescue JSON::ParserError
            raise ApiGouvCommons::TransportError.new(
              "invalid JSON body: #{body[0, 200]}",
              method: env.method,
              url: env.url.to_s
            )
          end

        env.body = parsed
      end
    end
  end
end

Faraday::Response.register_middleware(api_gouv_envelope: ApiGouvCommons::Middleware::Envelope)
