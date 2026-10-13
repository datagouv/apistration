# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 4a3dcb8512f6d4369ad90c4bdf056334579cd647).
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
