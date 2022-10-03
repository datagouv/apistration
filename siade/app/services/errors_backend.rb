require 'singleton'

class ErrorsBackend
  include Singleton

  def get(code_or_subcode)
    errors.find do |error|
      error['code'] == code_or_subcode ||
        error['subcode'] == code_or_subcode
    end
  end

  def provider_from_code(code_or_subcode)
    provider_hash[code_or_subcode[0..1]]
  end

  def provider_code_from_name(name)
    provider_hash.invert[name]
  end

  private

  def errors
    @errors ||= YAML.load_file(
      errors_file_path,
      aliases: true
    )
  end

  def errors_file_path
    Rails.root.join(
      'config/errors.yml'
    )
  end

  # rubocop:disable Metrics/MethodLength
  def provider_hash
    @provider_hash ||= {
      '00' => 'API Entreprise',
      '01' => 'INSEE',
      '02' => 'Infogreffe',
      '03' => 'DGFIP - Adélie',
      '04' => 'ACOSS',
      '05' => 'INPI',
      '06' => 'Qualibat',
      '07' => 'RNA',
      '08' => 'CNETP',
      '09' => 'ProBTP',
      '10' => 'MSA',
      '11' => 'OPQIBI',
      '12' => 'FNTP',
      '13' => 'Agefiph',
      '14' => 'Fabrique numérique des Ministères Sociaux',
      '15' => 'CMA France',
      '16' => 'DGDDI',
      '17' => 'Banque de France',
      '18' => 'Agence BIO',
      '19' => 'ADEME',
      '20' => 'API Geo',
      '21' => 'MI',
      '22' => 'RNM',
      '23' => 'CNAF',
      '24' => 'Pôle Emploi',
      '25' => 'MESRI',
      '26' => 'CNOUS',
      '27' => 'DGFIP - SVAIR',
      '50' => 'FranceConnect'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
