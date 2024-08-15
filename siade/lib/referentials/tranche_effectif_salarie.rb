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

  private

  def result
    return unless valid?

    @result ||= CSV.foreach(file_name, headers: true).find do |row|
      hash = row.to_hash.symbolize_keys
      return hash if hash[:code] == @code
    end
  end

  def file_name
    Rails.root.join('lib/referentials/files/tranche_effectif_salarie.csv')
  end
end
