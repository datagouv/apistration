# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: bbd1e5a224301367f0fb64b119ec11cb4398c172).
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
