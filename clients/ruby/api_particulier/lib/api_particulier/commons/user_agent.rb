# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: a892f7b7177b8df6fa167cfcce18cf92ef23c6b5).
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
