# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 7fba210b2ead8fd60ba2fa3ebe31d341c1229cc4).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiParticulier::Commons
  class RateLimit
    attr_reader :limit, :remaining, :reset_at

    def self.from_headers(headers)
      return nil if headers.nil?

      normalized = headers.transform_keys { |k| k.to_s.downcase }
      limit = parse_int(normalized['ratelimit-limit'])
      remaining = parse_int(normalized['ratelimit-remaining'])
      reset_at = parse_reset(normalized['ratelimit-reset'])

      return nil if limit.nil? && remaining.nil? && reset_at.nil?

      new(limit: limit, remaining: remaining, reset_at: reset_at)
    end

    def self.parse_int(value)
      return nil if value.nil? || value.to_s.strip.empty?

      Integer(value.to_s, 10)
    rescue ArgumentError
      nil
    end

    def self.parse_reset(value)
      ts = parse_int(value)
      return nil if ts.nil?

      Time.at(ts).utc
    end

    def initialize(limit:, remaining:, reset_at:)
      @limit = limit
      @remaining = remaining
      @reset_at = reset_at
    end

    def retry_after(now: Time.now)
      return nil if reset_at.nil?

      diff = reset_at.to_i - now.to_i
      diff.negative? ? 0 : diff
    end

    def to_h
      { limit: limit, remaining: remaining, reset_at: reset_at }
    end
  end
end
