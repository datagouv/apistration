# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: cadd23a519516ddfc74ee81c282d570c916571db).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiEntreprise::Commons
  class Response
    attr_reader :raw, :http_status, :headers, :rate_limit

    def initialize(raw:, http_status:, headers:, rate_limit: nil)
      @raw = raw.is_a?(Hash) ? raw : {}
      @http_status = http_status
      @headers = headers || {}
      @rate_limit = rate_limit
    end

    def data
      raw['data']
    end

    def links
      raw['links'] || {}
    end

    def meta
      raw['meta'] || {}
    end

    def success?
      http_status.to_i.between?(200, 299)
    end
  end
end
