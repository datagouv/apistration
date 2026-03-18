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
  inflect.acronym 'DGFIP'
  inflect.acronym 'SIADE'
  inflect.acronym 'OLD'
  inflect.acronym 'PDF'
  inflect.acronym 'RNA'
  inflect.acronym 'FNTP'
  inflect.acronym 'CNETP'
  inflect.acronym 'OPQIBI'
  inflect.acronym 'QUALIBAT'
  inflect.acronym 'MSA'
  inflect.acronym 'PROBTP'
  inflect.acronym 'BDNU'
  inflect.acronym 'AGEFIPH'
  inflect.acronym 'PROBTP'
  inflect.acronym 'RCS'
  inflect.acronym 'ACOSS'
  inflect.acronym 'INPI'
  inflect.acronym 'BDF'
  inflect.acronym 'RGE'
  inflect.acronym 'INPI'
  inflect.acronym 'EORI'
  inflect.acronym 'BIO'

  inflect.irregular 'appel_offre', 'appels_offres'
  inflect.irregular 'attestation_sociale', 'attestations_sociales'
  inflect.irregular 'attestation_fiscale', 'attestations_fiscales'
  inflect.irregular 'attestation_agefiph', 'attestations_agefiph'
  inflect.irregular 'extrait_rcs', 'extraits_rcs'
  inflect.irregular 'certificat_cnetp', 'certificats_cnetp'
  inflect.irregular 'cotisation_msa', 'cotisations_msa'
  inflect.irregular 'eligibilite_cotisation_retraite', 'eligibilites_cotisation_retraite'
  inflect.irregular 'ninja', 'ninja'
  inflect.irregular 'extrait_court_inpi', 'extraits_courts_inpi'
  inflect.irregular 'certificat_rge_ademe', 'certificats_rge_ademe'
  inflect.irregular 'aide_covid_effectifs', 'aides_covid_effectifs'
end
