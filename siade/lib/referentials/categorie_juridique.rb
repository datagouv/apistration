require 'csv'

class Referentials::CategorieJuridique
  include Referentials::DeprecatedDataTrackable

  attr_reader :code

  def initialize(code:)
    @code = code
  end

  def valid?
    valid = @code.is_a?(String) && @code.length == 4
    track_deprecated_data('Categorie Juridique', code) unless valid
    valid
  end

  def found?
    return false unless valid?

    found = !result.nil?
    track_deprecated_data('Categorie Juridique', code) unless found
    found
  end

  def libelle
    if found?
      result[:Libellé]
    else
      'non référencé'
    end
  end

  def as_json
    {
      code:,
      libelle:
    }
  end

  def self.table
    AppConfig.fetch(:referentials_categorie_juridique) do
      CSV.read(
        Rails.root.join('lib/referentials/files/categorie_juridique.csv'),
        headers: true
      ).each_with_object({}) { |row, acc|
        hash = row.to_hash.symbolize_keys
        acc[hash[:Code]] = hash if hash[:Code]
      }.freeze
    end
  end

  private

  def result
    return unless valid?

    self.class.table[@code]
  end
end
