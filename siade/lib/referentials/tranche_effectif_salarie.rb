require 'csv'

class Referentials::TrancheEffectifSalarie
  include Referentials::DeprecatedDataTrackable

  attr_reader :code, :date_reference

  def initialize(code:, date_reference:)
    @code = code
    @date_reference = date_reference
  end

  def valid?
    return false if @code.nil?

    valid = @code.is_a?(String) && @code.length == 2
    track_deprecated_data('Tranche effectif salarie', code) unless valid
    valid
  end

  def found?
    return false unless valid?

    found = !result.nil?
    track_deprecated_data('Tranche effectif salarie', code) unless found
    found
  end

  def de
    return unless found?
    return nil if result[:de] == 'null'

    result[:de].to_i
  end

  def a
    return unless found?
    return nil if result[:a] == 'null'

    result[:a].to_i
  end

  def intitule
    if found?
      result[:intitule]
    elsif !@code.nil?
      'non référencé'
    end
  end

  def as_json
    {
      de:,
      a:,
      code:,
      date_reference:,
      intitule:
    }
  end

  def self.table
    @table ||= CSV.read(
      Rails.root.join('lib/referentials/files/tranche_effectif_salarie.csv'),
      headers: true
    ).each_with_object({}) { |row, acc|
      hash = row.to_hash.symbolize_keys
      acc[hash[:code]] = hash if hash[:code]
    }.freeze
  end

  private

  def result
    return unless valid?

    self.class.table[@code]
  end
end
