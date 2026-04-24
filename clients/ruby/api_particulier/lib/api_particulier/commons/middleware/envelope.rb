# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 3f647e0d78209049ba64ba642be269590d3af52a).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'
require 'json'

module ApiParticulier::Commons
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
            raise ApiParticulier::Commons::TransportError.new(
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
