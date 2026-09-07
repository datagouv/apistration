# frozen_string_literal: true

class ExtractProviderFromPath
  PROVIDER_FROM_URL_TO_HUMANIZED = {
    'insee' => 'INSEE',
    'infogreffe' => 'Infogreffe',
    'dgfip' => 'DGFIP - Adélie',
    'urssaf' => 'ACOSS',
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
    'douanes' => 'DGDDI',
    'bdf' => 'Banque de France',
    'ademe' => 'ADEME',
    'ministere_interieur' => 'MI',
    'european_commission' => 'Commission Européenne',
    'banque_de_france' => 'Banque de France',
    'cma_france' => 'CMA France',
    'djepva' => 'DJEPVA',
    'gip_mds' => 'GIP-MDS',
    'qualifelec' => 'Qualifelec',
    'carif_oref' => 'CARIF-OREF',
    'cibtp' => 'CIBTP',
    'data_subvention' => 'DataSubvention'
  }.freeze

  attr_reader :path

  def initialize(path)
    @path = path
  end

  def perform
    PROVIDER_FROM_URL_TO_HUMANIZED[provider_from_url]
  end

  private

  def provider_from_url
    path.split('/')[2]
  end
end
