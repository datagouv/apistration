# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 4a3dcb8512f6d4369ad90c4bdf056334579cd647).
# Regenerate via clients/ruby/bin/sync_commons.

require_relative 'strategy'

module ApiEntreprise::Commons
  module Auth
    class BearerToken < Strategy
      def initialize(token)
        raise ArgumentError, 'token must be a non-empty string' if token.nil? || token.to_s.strip.empty?

        @token = token.to_s
      end

      def apply(request)
        request.headers['Authorization'] = "Bearer #{@token}"
      end
    end
  end
end
