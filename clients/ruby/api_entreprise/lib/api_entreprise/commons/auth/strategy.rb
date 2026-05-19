# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 0df8ad8033bacf8106a6a1b42aaf1e690c0f3147).
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
