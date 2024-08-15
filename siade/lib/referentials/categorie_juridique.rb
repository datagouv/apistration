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

  private

  def result
    return unless valid?

    @result ||= CSV.foreach(file_name, headers: true) do |row|
      hash = row.to_hash.symbolize_keys
      return hash if hash[:Code] == @code
    end
  end

  def file_name
    Rails.root.join('lib/referentials/files/categorie_juridique.csv')
  end
end
