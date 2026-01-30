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

  private

  def libelle
    @libelle ||= find_libelle || 'non référencé'
  end

  def find_libelle
    case @nomenclature
    when 'NAF2025'
      find_libelle_naf2025
    when 'NAFRev2'
      find_libelle_nafrev2
    end
  end

  def find_libelle_naf2025
    CSV.foreach(csv_path('NAF2025.csv'), headers: true, col_sep: ',') do |row|
      return row[2]&.strip if row[1]&.strip == @code
    end
    nil
  end

  def find_libelle_nafrev2
    CSV.foreach(csv_path('NAFRev2.csv'), headers: true, col_sep: ',') do |row|
      data = row.to_hash.symbolize_keys
      return data[:' Intitulés de la  NAF rév. 2, version finale ']&.strip if data[:Code]&.strip == @code
    end
    nil
  end

  def csv_path(filename)
    Rails.root.join("lib/referentials/files/#{filename}")
  end
end
