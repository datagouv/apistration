# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 46d0fae2bc55a1c378c766ea6875e4ad042bf580).
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
