# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 46d0fae2bc55a1c378c766ea6875e4ad042bf580).
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
