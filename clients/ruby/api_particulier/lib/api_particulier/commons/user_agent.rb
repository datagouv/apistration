# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 3f647e0d78209049ba64ba642be269590d3af52a).
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
