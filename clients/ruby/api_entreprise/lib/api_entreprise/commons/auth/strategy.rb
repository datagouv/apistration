# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 35aaaaedcd3b760511d070e4e4c101ca3c5cdb32).
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
