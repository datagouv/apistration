require_relative 'strategy'

module ApiGouvCommons
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
