# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: bbd1e5a224301367f0fb64b119ec11cb4398c172).
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
