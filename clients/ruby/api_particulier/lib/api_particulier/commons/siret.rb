# frozen_string_literal: true
# DO NOT EDIT — generated from clients/ruby/commons/ (source digest: 903f3b3aca1a59a6cb1a53ab98f72c365486fc1f).
# Regenerate via clients/ruby/bin/sync_commons.

module ApiParticulier::Commons
  module Siret
    module_function

    LA_POSTE_PATTERN = /\A356000000\d{5}\z/.freeze
    DIGITS_14 = /\A\d{14}\z/.freeze

    def valid?(value)
      return false if value.nil?
      return false unless value.to_s.match?(DIGITS_14)
      return true if value.to_s.match?(LA_POSTE_PATTERN)

      (luhn_checksum(value.to_s) % 10).zero?
    end

    def validate!(value, parameter:)
      return if valid?(value)

      raise InvalidSiretError,
            "#{parameter.inspect} must be a 14-digit SIRET passing the Luhn checksum (or a La Poste SIRET); got #{value.inspect}"
    end

    def luhn_checksum(value)
      accum = 0
      value.reverse.each_char.map(&:to_i).each_with_index do |digit, index|
        t = index.even? ? digit : digit * 2
        t -= 9 if t >= 10
        accum += t
      end
      accum
    end
  end
end
