# frozen_string_literal: true

class ExtractProviderFromPath
  attr_reader :path

  def initialize(path)
    @path = path
  end

  def perform
    provider_from_url_to_humanized[provider_from_url]
  end

  private

  def provider_from_url
    path.split('/')[2]
  end

  # rubocop:disable Metrics/MethodLength
  def provider_from_url_to_humanized
    {
      'insee' => 'INSEE',
      'infogreffe' => 'Infogreffe',
      'dgfip' => 'DGFIP - Adélie',
      'urssaf' => 'URSSAF',
      'inpi' => 'INPI',
      'qualibat' => 'Qualibat',
      'rna' => 'RNA',
      'cnetp' => 'CNETP',
      'probtp' => 'ProBTP',
      'msa' => 'MSA',
      'opqibi' => 'OPQIBI',
      'fntp' => 'FNTP',
      'fabrique_numerique_ministeres_sociaux' => 'Fabrique numérique des Ministères Sociaux',
      'cma' => 'CMA France',
      'douanes' => 'Douanes',
      'bdf' => 'Banque de France',
      'ademe' => 'ADEME',
      'ministere_interieur' => 'Ministère de l\'Intérieur',
      'european_commission' => 'Commission Européenne',
      'banque_de_france' => 'Banque de France',
      'cma_france' => 'CMA France',
      'djepva' => 'DJEPVA',
      'gip_mds' => 'GIP-MDS',
      'qualifelec' => 'Qualifelec',
      'carif_oref' => 'CARIF-OREF',
      'cibtp' => 'CIBTP',
      'data_subvention' => 'DataSubvention'
    }
  end
  # rubocop:enable Metrics/MethodLength
end
