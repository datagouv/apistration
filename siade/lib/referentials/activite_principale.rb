require 'csv'

class Referentials::ActivitePrincipale
  include Referentials::DeprecatedDataTrackable

  attr_reader :code, :nomenclature

  def initialize(code:, nomenclature:)
    @code = code
    @nomenclature = nomenclature
  end

  def to_h
    {
      code: @code,
      nomenclature: @nomenclature,
      libelle:
    }
  end

  def self.naf2025
    AppConfig.fetch(:referentials_activite_principale_naf2025) do
      CSV.read(
        Rails.root.join('lib/referentials/files/NAF2025.csv'),
        headers: true,
        col_sep: ','
      ).each_with_object({}) { |row, acc|
        key = row[1]&.strip
        acc[key] = row[2]&.strip if key
      }.freeze
    end
  end

  def self.nafrev2
    AppConfig.fetch(:referentials_activite_principale_nafrev2) do
      CSV.read(
        Rails.root.join('lib/referentials/files/NAFRev2.csv'),
        headers: true,
        col_sep: ','
      ).each_with_object({}) { |row, acc|
        data = row.to_hash.symbolize_keys
        key = data[:Code]&.strip
        acc[key] = data[:' Intitulés de la  NAF rév. 2, version finale ']&.strip if key
      }.freeze
    end
  end

  private

  def libelle
    @libelle ||= find_libelle || 'non référencé'
  end

  def find_libelle
    case @nomenclature
    when 'NAF2025'
      self.class.naf2025[@code]
    when 'NAFRev2'
      self.class.nafrev2[@code]
    end
  end
end
