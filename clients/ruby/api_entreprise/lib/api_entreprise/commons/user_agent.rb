# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 7fba210b2ead8fd60ba2fa3ebe31d341c1229cc4).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiEntreprise::Commons
  module UserAgent
    URL = 'https://github.com/datagouv/apistration'.freeze

    module_function

    def build(product:, version:, suffix: nil)
      base = "#{product}/#{version} (+#{URL})"
      suffix ? "#{base} #{suffix}" : base
    end
  end
end
