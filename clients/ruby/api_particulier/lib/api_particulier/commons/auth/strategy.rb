# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 7fba210b2ead8fd60ba2fa3ebe31d341c1229cc4).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiParticulier::Commons
  module Auth
    class Strategy
      def apply(request)
        raise NotImplementedError, "#{self.class} must implement #apply(request)"
      end
    end
  end
end
