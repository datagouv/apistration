# Be sure to restart your server when you modify this file.

# Add new inflection rules using the following format. Inflections
# are locale specific, and you may define rules for as many different
# locales as you wish. All of these examples are active by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.plural /^(ox)$/i, '\1en'
#   inflect.singular /^(ox)en/i, '\1'
#   inflect.irregular 'person', 'people'
#   inflect.uncountable %w( fish sheep )
# end

# These inflection rules are supported but not enabled by default:
# ActiveSupport::Inflector.inflections(:en) do |inflect|
#   inflect.acronym 'RESTful'
# end
#

ActiveSupport::Inflector.inflections(:en) do |inflect|
  inflect.acronym 'API'
  inflect.acronym 'MCP'
  inflect.acronym 'ELK'
  inflect.acronym 'HTTP'
  inflect.acronym 'JSONAPI'
  inflect.acronym 'OAuth2'
  inflect.acronym 'PDF'
  inflect.acronym 'ZIP'
  inflect.acronym 'TVA'
  inflect.acronym 'INE'
  inflect.acronym 'SSL'
  inflect.acronym 'VIES'
  inflect.acronym 'IR'
  inflect.acronym 'QF'

  inflect.acronym 'ADELIE'

  inflect.acronym 'ACOSS'
  inflect.acronym 'ADEME'
  inflect.acronym 'ANTS'
  inflect.acronym 'BDF'
  inflect.acronym 'CIBTP'
  inflect.acronym 'CNAF'
  inflect.acronym 'CNAV'
  inflect.acronym 'EAJE'
  inflect.acronym 'CNETP'
  inflect.acronym 'CNOUS'
  inflect.acronym 'DGDDI'
  inflect.acronym 'DGFIP'
  inflect.acronym 'DJEPVA'
  inflect.acronym 'DSNJ'
  inflect.acronym 'EORI'
  inflect.acronym 'FNTP'
  inflect.acronym 'GIP'
  inflect.acronym 'INPI'
  inflect.acronym 'INPI'
  inflect.acronym 'INSEE'
  inflect.acronym 'MESRI'
  inflect.acronym 'MEN'
  inflect.acronym 'MI'
  inflect.acronym 'MSA'
  inflect.acronym 'RNCPS'
  inflect.acronym 'MDS'
  inflect.acronym 'OPQIBI'
  inflect.acronym 'PROBTP'
  inflect.acronym 'PROBTP'
  inflect.acronym 'QUALIBAT'
  inflect.acronym 'RCS'
  inflect.acronym 'RGE'
  inflect.acronym 'RNA'
  inflect.acronym 'RNE'
  inflect.acronym 'RNM'
  inflect.acronym 'SDH'
  inflect.acronym 'URSSAF'

  inflect.irregular 'aide_covid_effectifs', 'aides_covid_effectifs'
  inflect.irregular 'appel_offre', 'appels_offres'
  inflect.irregular 'attestation_fiscale', 'attestations_fiscales'
  inflect.irregular 'attestation_sociale', 'attestations_sociales'
  inflect.irregular 'certificat_cnetp', 'certificats_cnetp'
  inflect.irregular 'certification_ingenierie', 'certifications_ingenierie'
  inflect.irregular 'certification_qualiopi_france_competences', 'certifications_qualiopi_france_competences'
  inflect.irregular 'certificat_rge_ademe', 'certificats_rge_ademe'
  inflect.irregular 'certificat_rge', 'certificats_rge'
  inflect.irregular 'cotisation_msa', 'cotisations_msa'
  inflect.irregular 'eligibilite_cotisation_retraite', 'eligibilites_cotisation_retraite'
  inflect.irregular 'extrait_rcs', 'extraits_rcs'
  inflect.irregular 'mandataire_social', 'mandataires_sociaux'
  inflect.irregular 'ninja', 'ninja'
  inflect.irregular 'service_national', 'services_nationaux'
end
