# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 35aaaaedcd3b760511d070e4e4c101ca3c5cdb32).
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
