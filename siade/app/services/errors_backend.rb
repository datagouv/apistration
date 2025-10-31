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
      '24' => 'France Travail',
      '25' => 'MESRI',
      '26' => 'CNOUS',
      '27' => 'DGFIP - SVAIR',
      '28' => 'Commission Européenne',
      '29' => 'DJEPVA',
      '30' => 'MEN',
      '31' => 'GIP-MDS',
      '32' => 'Qualifelec',
      '33' => 'CARIF-OREF',
      '34' => 'INPI - RNE',
      '35' => 'CNAF & MSA',
      '36' => 'Sécurité sociale',
      '37' => 'CNAV',
      '38' => 'CIBTP',
      '39' => 'DSNJ',
      '40' => 'RNCPS',
      '41' => 'SDH',
      '42' => 'ANTS',
      '51' => 'FranceConnect v2',
      '52' => 'DataSubvention'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
