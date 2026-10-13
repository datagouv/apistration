# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 4a3dcb8512f6d4369ad90c4bdf056334579cd647).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiEntreprise::Commons
  module Auth
    class Strategy
      def apply(request)
        raise NotImplementedError, "#{self.class} must implement #apply(request)"
      end
    end
  end
end
