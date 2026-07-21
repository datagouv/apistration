# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 0df8ad8033bacf8106a6a1b42aaf1e690c0f3147).
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
