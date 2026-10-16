# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: cadd23a519516ddfc74ee81c282d570c916571db).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiParticulier::Commons
  module UserAgent
    URL = 'https://github.com/datagouv/apistration'.freeze

    module_function

    def build(product:, version:, suffix: nil)
      base = "#{product}/#{version} (+#{URL})"
      suffix ? "#{base} #{suffix}" : base
    end
  end
end
