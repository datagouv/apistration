require 'csv'

class SIADE::V2::Referentials::ActivitePrincipale
  include SIADE::V2::Referentials::DeprecatedDataTrackable

  attr_reader :code, :nomenclature

  def initialize(code:, nomenclature:)
    @code = code
    @nomenclature = nomenclature
  end

  def valid?
    if latest_nomenclature?
      track_deprecated_data(nomenclature, code) unless valid_naf?
      valid_naf?
    else
      false
    end
  end

  def found?
    return false unless valid?

    found = !!result
    track_deprecated_data(nomenclature, code) unless found
    found
  end

  def libelle
    if found?
      result
    else
      latest_nomenclature? ? 'non référencé' : "ancienne révision NAF (#{@nomenclature}) non supportée"
    end
  end

  def code_dotless
    @code&.delete('.')
  end

  def as_json
    {
      code: code,
      nomenclature: nomenclature,
      libelle: libelle
    }
  end

  private

  def valid_naf?
    @code.is_a?(String) && @code.length == 6
  end

  def latest_nomenclature?
    @nomenclature == 'NAFRev2'
  end

  def result
    return unless valid?

    @result ||= find_in_csv || find_in_exceptions
  end

  def find_in_csv
    CSV.foreach(file_name, headers: true) do |row|
      hash = row.to_hash.symbolize_keys
      return hash[:' Intitulés de la  NAF rév. 2, version finale '] if hash[:Code] == @code
    end
  end

  def find_in_exceptions
    return 'En instance de chiffrement' if @code == '00.00Z'
  end

  def file_name
    Rails.root.join('lib', 'siade', 'v2', 'referentials', 'files', 'NAFRev2.csv')
  end
end
