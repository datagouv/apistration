# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
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
