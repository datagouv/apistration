# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: a892f7b7177b8df6fa167cfcce18cf92ef23c6b5).
# Regenerate via clients/ruby/bin/sync_commons.

require_relative 'strategy'

module ApiParticulier::Commons
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
