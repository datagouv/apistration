# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
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
