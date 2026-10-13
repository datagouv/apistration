# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: cadd23a519516ddfc74ee81c282d570c916571db).
# Regenerate via clients/ruby/bin/sync_commons.

require 'faraday'
require 'json'

module ApiEntreprise::Commons
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
            raise ApiEntreprise::Commons::TransportError.new(
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
