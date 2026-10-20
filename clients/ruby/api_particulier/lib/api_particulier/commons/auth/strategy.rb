# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: cadd23a519516ddfc74ee81c282d570c916571db).
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
